import 'package:flutter/material.dart';

import 'styles/styles.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({Key? key}) : super(key: key);

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

    return Container(
        child: Padding(
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
                      thumbColor: WidgetStateProperty.all<Color>(Colors.white),
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
                  onPressed: () async => await saveTaskAndRefresh(
                      dac, title, description, repeat, endDate!, context),
                  child: Text(
                    "Save",
                    style: CustomThemes.styledPlainText,
                  ))
            ],
          )
        ],
      ),
    ));
  }
}
