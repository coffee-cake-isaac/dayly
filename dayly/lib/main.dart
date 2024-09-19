import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dayly/logic/task_dac.dart';
import 'package:dayly/ui/main/task_card.dart';
import 'package:dayly/ui/main/add_task.dart';
import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'ui/main/styles/styles.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 38, 40, 45)),
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ToastificationWrapper(child: MaterialApp(home: MainApp())));
}

class MainApp extends StatelessWidget {
  var dac = Get.put(TaskDac());

  final ValueNotifier<DateTime?> _currentSelectedDate =
      ValueNotifier<DateTime?>(null);

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    dac.createDatabase();
    return GetMaterialApp(
      onReady: () async => await dac.getAllTasks(),
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 38, 40, 45),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              "Add Task",
              style: CustomThemes.styledPlainText,
            ),
            backgroundColor: Colors.grey,
            shape: const StadiumBorder(),
            onPressed: () {
              showAddDialog(context, dac);
            },
          ),
          body: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: UiQuote()),
                  ValueListenableBuilder<DateTime?>(
                      valueListenable: _currentSelectedDate,
                      builder: (context, dateTime, child) {
                        return CalendarTimeline(
                          initialDate: _currentSelectedDate.value != null
                              ? _currentSelectedDate.value as DateTime
                              : DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          onDateSelected: (date) async => {
                            _currentSelectedDate.value = date,
                            await dac.getAllTasks(date)
                          },
                          leftMargin: 20,
                          monthColor: Colors.white,
                          dayColor: Colors.white,
                          activeDayColor: Colors.white,
                          activeBackgroundDayColor: Colors.grey,
                          locale: 'en_ISO',
                        );
                      }),
                  Expanded(
                    child: AnimationLimiter(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(15),
                                  itemCount: dac.tasks.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                                child: SizedBox(
                                                    height: 145,
                                                    child: TaskCard(
                                                        dac: dac,
                                                        index: index)))));
                                  },
                                )))),
                  )
                ],
              ))),
    );
  }

  void showAddDialog(BuildContext context, TaskDac dac) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTask(dac: dac)));
  }
}
