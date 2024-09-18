import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dayly/logic/task_dac.dart';
import 'package:dayly/models/frequency.dart';
import 'package:dayly/models/task.dart';
import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'ui/main/styles/styles.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Color.fromARGB(255, 38, 40, 45)),
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget {
  var dac = Get.put(TaskDac());

  final ValueNotifier<DateTime?> _dateNotifier = ValueNotifier<DateTime?>(null);
  final ValueNotifier<bool> _switchNotifier = ValueNotifier<bool>(false);

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
                  CalendarTimeline(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateSelected: (date) async => await dac.getAllTasks(date),
                    leftMargin: 20,
                    monthColor: Colors.white,
                    dayColor: Colors.white,
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: Colors.grey,
                    locale: 'en_ISO',
                  ),
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
                                                    child: Card(
                                                        elevation: 7,
                                                        color: const Color.fromARGB(255, 98, 98, 98),
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                              Text(
                                                                dac.tasks[index].name!,
                                                                style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w300),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.calendar_today,
                                                                    color: Colors.white,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    DateFormat('M/d/yy h:mma').format(dac.tasks[index].dueDate!),
                                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Text(
                                                                dac.tasks[index].description!,
                                                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
                                                              ),
                                                              const SizedBox(height: 2),
                                                            ])))))));
                                  },
                                )))),
                  )
                ],
              ))),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateNotifier.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != _dateNotifier.value) {
      _dateNotifier.value = picked;
    }
  }

  void showAddDialog(BuildContext context, TaskDac dac) {
    late var title = "";
    late var description = "";
    late DateTime? endDate = DateTime.now();
    late var repeat = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: const Color.fromARGB(255, 82, 72, 72),
          title: Text("Create a Task", style: CustomThemes.styledPlainText),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => title = value,
                    style: TextStyle(color: Colors.white),
                    decoration: CustomThemes.getDecor('Title'),
                  ),
                  const SizedBox(height: 10),
                  TextField(onChanged: (value) => description = value, style: TextStyle(color: Colors.white), decoration: CustomThemes.getDecor('Description')),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<DateTime?>(
                      valueListenable: _dateNotifier,
                      builder: (context, dateTime, child) {
                        return TextField(
                          style: CustomThemes.styledPlainText,
                          controller: TextEditingController(
                            text: dateTime != null ? "${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}" : '',
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: CustomThemes.getDecor('MM/DD/YYYY'),
                        );
                      }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Repeat",
                        style: CustomThemes.styledPlainText,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: _switchNotifier,
                          builder: (context, value, child) {
                            return Switch(
                              value: value,
                              activeColor: Colors.green,
                              thumbColor: MaterialStateProperty.all<Color>(Colors.white),
                              onChanged: (newValue) {
                                _switchNotifier.value = newValue;
                              },
                            );
                          }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.grey)),
                          onPressed: () => saveTaskAndRefresh(dac, title, description, repeat, endDate),
                          child: Text(
                            "Save",
                            style: CustomThemes.styledPlainText,
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future? saveTaskAndRefresh(TaskDac dac, String title, String description, bool repeat, DateTime endDate) {
    dac.insertTask(Task(name: title, description: description, isRepeating: repeat, dueDate: endDate, frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.days)));
  }
}
