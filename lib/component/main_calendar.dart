import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; //  날짜 선택시 실행되는 콜백 함수
  final DateTime selectedDate; // 선택된 날짜

  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr', // 한국어로 언어 변경
      onDaySelected: onDaySelected, // 요일 선택 이벤트를 처리
      selectedDayPredicate: (date) => // 주어진 '날짜'가 '선택된 날짜'와 일치하는지 확인
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      // 날짜 범위를 정의
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      focusedDay: DateTime.now(), //  달력이 처음 표시될 때 처음에는 현재 날짜에 초점을 맞춘다.
      headerStyle: const HeaderStyle(
        titleCentered: true, // 헤더 제목 가운데 배치
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false, // 오늘 날짜가 달력에서 시각적으로 강조 표시되는지 여부를 결정
        // 기본 박스 스타일 지정
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        // 주말 셀 박스 스타일 지정
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        // 선택한 날짜를 나타내는 셀 박스 스타일 지정
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 2.0,
          ),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekNumberTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
      ),
    );
  }
}
