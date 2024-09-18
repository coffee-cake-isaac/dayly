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

  final ValueNotifier<DateTime?> _dateNotifier = ValueNotifier<DateTime?>(null);
  final ValueNotifier<bool> _switchNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> _currentSelectedDate =
      ValueNotifier<DateTime?>(null);

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
                                                    child: Card(
                                                        elevation: 7,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 98, 98, 98),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    dac
                                                                        .tasks[
                                                                            index]
                                                                        .name!,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            28,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .calendar_today,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        DateFormat('M/d/yy h:mma').format(dac
                                                                            .tasks[index]
                                                                            .dueDate!),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    dac
                                                                        .tasks[
                                                                            index]
                                                                        .description!,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          2),
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
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => title = value,
                    style: TextStyle(color: Colors.white),
                    decoration: CustomThemes.getDecor('Title'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) => description = value,
                      style: TextStyle(color: Colors.white),
                      decoration: CustomThemes.getDecor('Description')),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<DateTime?>(
                      valueListenable: _dateNotifier,
                      builder: (context, dateTime, child) {
                        endDate = dateTime ?? DateTime.now();
                        return TextField(
                          textInputAction: TextInputAction.next,
                          style: CustomThemes.styledPlainText,
                          controller: TextEditingController(
                            text: dateTime != null
                                ? "${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}"
                                : '',
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
                              thumbColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
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
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.grey)),
                          onPressed: () async => await saveTaskAndRefresh(dac,
                              title, description, repeat, endDate!, context),
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

  Future? saveTaskAndRefresh(TaskDac dac, String title, String description,
      bool repeat, DateTime endDate, BuildContext context) async {
    await dac.insertTask(Task(
        name: title,
        description: description,
        isRepeating: repeat,
        dueDate: endDate,
        frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.days)));
    await dac.getAllTasks();
    if (context.mounted) {
      Navigator.pop(context);
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: Duration(seconds: 5),
        primaryColor: Colors.green,
        title: Text(
          'Success',
          style: TextStyle(color: Colors.black),
        ),
        description: Text(
          "Successfully created a new Dayly task!",
          style: TextStyle(color: Colors.black),
        ),
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.check),
        showIcon: true, // show or hide the icon
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
      );
    }
  }
}
