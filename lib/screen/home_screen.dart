import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 선택된 날짜를 관리할 변수
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
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
                  onDaySelected: onDaySelected, // 날짜가 선택됐을 때 실행할 함수
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              StreamBuilder<List<Schedule>>(
                  stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                  builder: ((context, snapshot) {
                    return TodayBanner(
                      selectedDate: selectedDate,
                      count: snapshot.data?.length ?? 0,
                    );
                  })),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                // 일정 정보가 Stream으로 제공되기 때문에 Streambuilder 사용
                child: StreamBuilder<List<Schedule>>(
                    stream:
                        GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      // 화면에 보이는 값들만 렌더링하는 리스트
                      return ListView.builder(
                        // 리스트에 입력할 값들의 총 개수
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final schedule = snapshot.data![index];
                          return Dismissible(
                            // 밀어서 삭제하는 제스처
                            key: ObjectKey(schedule.id), // 유니크한 키값
                            direction:
                                DismissDirection.startToEnd, // 밀기 방향-> 왼쪽에서 오른쪽
                            onDismissed: (DismissDirection direction) {
                              GetIt.I<LocalDatabase>()
                                  .removeSchedule(schedule.id);
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
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
