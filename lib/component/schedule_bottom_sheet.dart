import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:get_it/get_it.dart';
import '../database/drift_database.dart';
import 'package:drift/drift.dart' hide Column;

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜 상위 위젯에서 입력받기(홈 위젯)

  const ScheduleBottomSheet({super.key, required this.selectedDate});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

// 일정 정보를 입력할 수 있는 위젯
class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  // 폼 key 작성 ->  폼(Form) 위젯을 사용하여 사용자 입력을 유효성 검사하고 처리하기 위해
  final GlobalKey<FormState> formKey = GlobalKey(); // 폼키 생성

  int? startTime; // 시작 시간 저장 변수
  int? endTime; // 종료 시간 저장 변수
  String? content; // 일정 내용 저장 변수

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      // 텍스트 필드를 한번에 관리 할 수 있는 폼
      key: formKey, // 폼을 조작할 키값
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 +
              bottomInset, // 화면 반 높이에 키보드 높이 추가
          color: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            // 시간 관련 텍스트 필드와 내용관련 텍스트 필드 세로로 배치
            child: Column(
              children: [
                // 시작 시간 종료 시간 가로로 배치
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          // 저장이 실행되면 startTime 변수에 텍스트 필드값 저장
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: '종료 시간', // 종료시간 입력 필드
                        isTime: true,
                        onSaved: (String? val) {
                          // 저장이 실행되면 endTime 변수에 텍스트 필드갑 저장
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: '내용', // 내용 입력 필드
                    isTime: false,
                    onSaved: (String? val) {
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // 저장버튼
                    onPressed: onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() async {
    if (formKey.currentState!.validate()) {
      // 폼 검증하기
      formKey.currentState!.save(); // 폼 저장하기

      // print(startTime);
      // print(endTime);
      // print(content);
      int result = await GetIt.I<LocalDatabase>().createSchedule(//일정 생성
          SchedulesCompanion(
        startTime: Value(startTime!),
        endTime: Value(endTime!),
        content: Value(content!),
        date: Value(widget.selectedDate),
      ));
      print('result : ${result}');
      Navigator.of(context).pop(); // 일정 생성 후 화면 뒤로가기
    }
  }
  // SchedulesCompanion 객체를 생성하여 새로운 일정의 속성들을 지정해줍니다.
  //각 속성은 Value 클래스로 래핑되어야 합니다.
  // startTime, endTime, content, date 속성들은 사용자가 입력한 값들입니다.

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }
    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    }

    return null;
  }
}
