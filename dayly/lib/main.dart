import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dayly/ui/main/task_card_preview.dart';
import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stacked_listview/stacked_listview.dart';

import 'models/data.dart';
import 'ui/main/normal_list.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color.fromRGBO(58, 66, 86, 1.0),
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          floatingActionButton: FloatingActionButton.extended(
            label: Text("Add Task"),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(15),
                      itemCount: Data.length,
                      itemBuilder: (context, index) => Container(
                          height: 135,
                          child: Card(
                              elevation: 7,
                              color: const Color.fromARGB(255, 105, 122, 160),
                              child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    Data[index].name!,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  )))),
                    ),
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
