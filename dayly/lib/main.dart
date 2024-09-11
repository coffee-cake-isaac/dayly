import 'package:dayly/ui/main/filter_chips.dart';
import 'package:dayly/ui/main/task_card.dart';
import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void main() {
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
              onPressed: () {
                print("Hello, world!");
              },
              label: const Text("New Task")),
          body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      const Center(child: UiQuote()),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [FilterChips()],
                        ),
                      ),
                      SizedBox(
                          height: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  color: Colors.green,
                                  child: Row(
                                    children: [
                                      Text(
                                        DateFormat.EEEE()
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  )),
                              Container(
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '${DateTime.now().day}',
                                          style: const TextStyle(
                                              fontSize: 80,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                        ),
                                        Text(
                                          DateFormat.MMM()
                                              .format(DateTime.now()),
                                          style: const TextStyle(
                                              fontSize: 56,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w200,
                                              height: 1),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "435 Completed Tasks",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "435 Completed Tasks",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "435 Completed Tasks",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      SingleChildScrollView(
                        child: Expanded(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: 18,
                                itemBuilder: (BuildContext context, int index) {
                                  return const TaskCard();
                                })),
                      )
                    ],
                  ))))),
    );
  }
}
