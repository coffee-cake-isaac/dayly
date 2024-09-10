import 'package:dayly/ui/main/ui_quote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                print("Hello, world!");
              },
              label: const Text("New Task")),
          body: const SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [UiQuote()],
                  )))),
    );
  }
}
