// 드리프트를 사용하면 클래스를 선언해서 테이블을 생성 할 수 있다.
// code generation -> 드리프트가 자동으로 테이블과 관련된 기능을 코드로 생성해줌
import 'package:drift/drift.dart';

class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()(); // PRIMARY KEY
  TextColumn get content => text()(); // 내용, 글자 열
  DateTimeColumn get date => dateTime()(); // 일정 날짜, 날짜 열
  IntColumn get startTime => integer()(); // 시작 시간
  IntColumn get endTime => integer()(); // 종료 시간
}
