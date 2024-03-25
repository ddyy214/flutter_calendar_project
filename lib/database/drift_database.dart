// 자동으로 코드 생성을 사용하려면 part 파일을 지정해야한다.
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';

part 'drift_database.g.dart'; // part 파일 지정

@DriftDatabase(
  // 사용할 테이블 등록
  tables: [
    Schedules,
  ],
)

// class LocalDatabase extends _$LocalDatabase {}
// 여기까지 작성하고 터미널 -> flutter pub run build_runner build 명령어 실행
// Colde Generation으로 생성할 클래스 상속
class LocalDatabase extends _$LocalDatabase {
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
/**
 *  _$LocalDatabase 상속 받아서 select(); 쓸수 있는 거임
 *  일회성을 가져오는 get()함수와 변화가 있을 때마다 자동으로 테이터를 불러오는 watch() 함수
 *  get은 특정 상황의 데이터를 가져올 때 사용, watch는 새로운 값을 반영해줘야 할 때 사용
 *  
 */

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
/**
 * insert 함수도 제공해줌
 * into() 함수를 먼저 사용해서 어떤 테이블에 데이터를 넣을지 지정해줌
 * 
 * 
 */
}
