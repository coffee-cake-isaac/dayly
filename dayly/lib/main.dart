import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dayly/logic/task_dac.dart';
import 'package:dayly/models/frequency.dart';
import 'package:dayly/models/task.dart';
import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'models/data.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color.fromRGBO(58, 66, 86, 1.0),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  TaskDac dac = TaskDac();
  await dac.createDatabase();
  await dac.insertTask(Task(
      name: "Test",
      isDone: false,
      description: "A description",
      dueDate: DateTime.now(),
      isRepeating: false,
      frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.hours)));
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
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          floatingActionButton: FloatingActionButton.extended(
            label: Text("Add Task"),
            backgroundColor: Colors.lightBlueAccent,
            shape: StadiumBorder(),
            onPressed: () {
              print("Hello, world!");
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
                    monthColor: Colors.blueGrey,
                    dayColor: Colors.lightBlueAccent[200],
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: Colors.lightBlueAccent,
                    selectableDayPredicate: (date) => date.day != 23,
                    locale: 'en_ISO',
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(15),
                          itemCount: dac.tasks.length,
                          itemBuilder: (context, index) => Container(
                              height: 135,
                              child: Card(
                                  elevation: 7,
                                  color:
                                      const Color.fromARGB(255, 105, 122, 160),
                                  child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        dac.tasks[index].name!,
                                        style: const TextStyle(
                                            fontSize: 28,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                      )))),
                        )),
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
