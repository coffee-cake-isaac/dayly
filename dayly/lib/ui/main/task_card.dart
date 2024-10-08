import 'package:dayly/logic/task_dac.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final index;

  const TaskCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var tasks = Provider.of<TaskDac>(context, listen: false).tasks;

    return Card(
        elevation: 7,
        color: const Color.fromARGB(255, 98, 98, 98),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                tasks[index].name!,
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
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
                    DateFormat('M/d/yy h:mma').format(tasks[index].dueDate!),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                tasks[index].description!,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 2),
            ])));
  }
}
