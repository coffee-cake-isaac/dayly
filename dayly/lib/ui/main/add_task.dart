import 'package:dayly/logic/task_dac.dart';
import 'package:dayly/models/frequency.dart';
import 'package:dayly/models/task.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'styles/styles.dart';

class AddTask extends StatelessWidget {
  final TaskDac dac;

  const AddTask({Key? key, required this.dac}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late var title = "";
    late var description = "";
    late DateTime? endDate = DateTime.now();
    late var repeat = false;
    final ValueNotifier<DateTime?> _dateNotifier =
        ValueNotifier<DateTime?>(null);
    final ValueNotifier<bool> _switchNotifier = ValueNotifier<bool>(false);

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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 40, 45),
      body: SafeArea(
          child: Container(
              child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Create a Task",
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ],
            ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.grey)),
                      onPressed: () async => await saveTaskAndRefresh(
                          dac, title, description, repeat, endDate!, context),
                      child: Text(
                        "Save",
                        style: CustomThemes.styledPlainText,
                      )),
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              "YOU HAVE ADDED 432 TASKS THIS YEAR! WAY TO GO! 🎉",
              style: CustomThemes.smallStyledPlainText,
            )
          ],
        ),
      ))),
    );
  }
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
