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
import 'models/data.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Color.fromARGB(255, 38, 40, 45)),
  );

  WidgetsFlutterBinding.ensureInitialized();

  TaskDac dac = TaskDac();
  await dac.createDatabase();

  await dac.getAllTasks();

  runApp(MainApp(dac: dac));
}

class MainApp extends StatelessWidget {
  final TaskDac dac;

  const MainApp({super.key, required this.dac});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 38, 40, 45),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text("Add Task"),
            backgroundColor: Colors.grey,
            shape: const StadiumBorder(),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Expanded(
                    child: AlertDialog(
                      title: Text('Welcome'),
                      content: Text('GeeksforGeeks'),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('ACCEPT'),
                        ),
                      ],
                    ),
                  );
                },
              );
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
                    onDateSelected: (date) => print(date),
                    leftMargin: 20,
                    monthColor: Colors.white,
                    dayColor: Colors.white,
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: Colors.grey,
                    selectableDayPredicate: (date) => date.day != 23,
                    locale: 'en_ISO',
                  ),
                  Expanded(
                    child: AnimationLimiter(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: ListView.builder(
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
                                                    color: const Color.fromARGB(
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
                                                                dac.tasks[index]
                                                                    .name!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        28,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
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
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    DateFormat('M/d/yy h:mma').format(dac
                                                                        .tasks[
                                                                            index]
                                                                        .dueDate!),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                dac.tasks[index]
                                                                    .description!,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                            ])))))));
                              },
                            ))),
                  )
                ],
              ))),
    );
  }
}

// Function to map the index to valid green shades
int getShadeFromIndex(int index) {
  const shades = [300, 400, 500, 600, 700, 800, 900];
  return shades[index % shades.length]; // Cycle through the shades
}
