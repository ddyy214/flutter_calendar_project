import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
          // 포커스 된 날짜
          focusedDay: DateTime.now(),
          // 달력의 제일 첫 번째 날짜
          firstDay: DateTime.utc(1900, 1, 1),
          // 달력의 제일 마지막 날짜
          lastDay: DateTime.utc(2999, 12, 31),
          //선택된 날짜를 인식하는 함수
          selectedDayPredicate: (DateTime day) {
            // final now = DateTime.now();

            // return DateTime(day.year, day.month, day.day).isAtSameMomentAs(
            //   DateTime(now.year, now.month, now.day),
            // );
            return isSameDay(selectDay, day);
          },
          // 날짜가 선택됐을 때 실행할 함수
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            print(selectedDay);
            print(focusedDay);
            setState(() {
              selectDay = selectedDay;
            });
          },
          // 날짜 페이지가 변경됐을 때 실행할 함수
          onPageChanged: (DateTime focusedDay) {},
          // 기간 선택 모드
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          // 기간이 선택됐을 때 실행할 함수
          // onRangeSelected:
          //     (DateTime? start, DateTime? end, DateTime focusedDay) {},
        ),
      ),
    );
  }
}
