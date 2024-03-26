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


// CREATE TABLE Schedules (
//    id INTEGER PRIMARY KEY AUTOINCREMENT,
//    content VARCHAR NOT NULL,
//    date DATETIME,
//    startTime INTEGER,
//    endTime INTEGER
//    )


/**
 * 
 * "시퀀스"의 개념은 고유한 숫자를 생성한다는 점에서 유사하지만 
 * SQLite의 AUTOINCREMENT는 테이블 내의 열에만 적용됩니다. 
 * 테이블에 삽입된 각각의 새 행이 지정된 열에서 고유하고 점진적으로 
 * 더 높은 값을 얻도록 보장합니다.
 * 요약하면 'AUTOINCREMENT'는 데이터베이스 테이블의 열에 적용되는 속성으로,
 * 테이블에 삽입된 각 새 행이 해당 열에서 고유하고 점진적으로 더 높은 값을 갖도록
 * 보장합니다. 이는 시퀀스와 같은 별도의 엔터티가 아닌 SQLite의 기능입니다.
 * 
 */

/**
 * 스키마는 데이터베이스 시스템의 데이터 구성을 정의하는 구조를 나타냅니다. 
 * 여기에는 데이터베이스 내에서 데이터가 저장, 액세스 및 조작되는 방식을 제어하는 ​
 * ​테이블, 열, 데이터 유형, 관계, 제약 조건 및 기타 속성에 대한 설명이 포함됩니다.
 */