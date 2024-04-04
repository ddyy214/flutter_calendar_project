import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ScheduleProvider>(); //  프로바이더 변경이 있을 때마다 build() 함수 재실행
    final selectedDate = provider.selectedDate; // 선택된 날짜 가져오기
    final schedules =
        provider.cache[selectedDate] ?? []; // 선택된 날짜에 해당되는 일정들 가져오기

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          // BottomSheet 열기
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true, // 배경 탭했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate, // 선택된 날짜 넘겨주기
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 400,
              // 매인 캘린더
              child: MainCalendar(
                selectedDate: selectedDate, // 선택된 날짜 전달하기
                onDaySelected: (selectedDate, focusedDate) => onDaySelected(
                    selectedDate, focusedDate, context), // 날짜가 선택됐을 때 실행할 함수
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDate: selectedDate,
              count: schedules.length,
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    // 밀어서 삭제하는 제스처
                    key: ObjectKey(schedule.id), // 유니크한 키값
                    direction: DismissDirection.startToEnd, // 밀기 방향-> 왼쪽에서 오른쪽
                    onDismissed: (DismissDirection direction) {
                      // GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                      provider.deleteSchedule(
                          date: selectedDate, id: schedule.id);
                    },

                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}
