import 'package:dayly/logic/quote_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiQuote extends StatelessWidget {
  const UiQuote({super.key});

  @override
  Widget build(BuildContext context) {
    final quote = Get.put(QuoteLogic());
    quote.getQuote();

    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Obx(() => Text(
                quote.quote?.message.value ?? "Uh-oh!",
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 8.0),
          Text(
            ' -${quote.quote?.author.value ?? "No message found!"}',
            // ignore: prefer_const_constructors
            style: TextStyle(fontSize: 16),
          ),
        ]));
  }
}
