import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              print("Hello, world!");
            },
            label: const Text("New Task")),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text("Dayly"),
            ),
          ],
        ),
      ),
    );
  }
}
