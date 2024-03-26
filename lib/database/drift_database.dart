import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// 자동으로 코드 생성을 사용하려면 part 파일을 지정해야한다.
part 'drift_database.g.dart'; // part 파일 지정

// 코드 제너레이터에게 테이블 클래스 알려주는 기능
@DriftDatabase(
  tables: [
    Schedules,
  ],
)

// class LocalDatabase extends _$LocalDatabase {}
// 여기까지 작성하고 터미널 -> flutter pub run build_runner build 명령어 실행
// Colde Generation으로 생성할 클래스 상속

class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection()); //LazyDatabase 객체 입력 받기

  @override
  int get schemaVersion => 1;

  // 드리프트 데이터베이스 클래스는 필수로 schemaVersion 값을 지정해줘야 함.
  // 기본적으로 1부터 시작하고 테이블 변화가 있을 때마다 1씩 올려서 변화를 드리프트에
  // 알려줘야함.

  // 데이터를 조회하고 변화 감지
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();

  // _$LocalDatabase 상속 받아서 select(); 쓸수 있는 거임
  // 일회성을 가져오는 get()함수와 변화가 있을 때마다 자동으로 테이터를 불러오는 watch() 함수
  // get은 특정 상황의 데이터를 가져올 때 사용, watch는 새로운 값을 반영해줘야 할 때 사용

  // 데이터 추가
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  // 데이터 삭제
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where(((tbl) => tbl.id.equals(id)))).go();
}

// LazyDatabase 반환 함수
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
    // 네이티브 데이터베이스 위치에 db.sqlite라는 파일로 데이터베이스 파일이 만들어짐
  });
}
