import 'package:dayly/models/quote.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UiQuote extends StatelessWidget {
  const UiQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Quote(),
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Consumer<Quote>(builder: (context, quote, child) {
                  if (quote.isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return Container(
                        child: Text(
                      quote.message,
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: ThemeData.estimateBrightnessForColor(
                                      const Color.fromRGBO(58, 66, 86, 1.0)) ==
                                  Brightness.light
                              ? Colors.green
                              : Colors.white),
                      textAlign: TextAlign.center,
                    ));
                  }
                }),
                Consumer<Quote>(builder: (context, quote, child) {
                  if (quote.isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return Container(
                        child: Text(
                      quote.author,
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: ThemeData.estimateBrightnessForColor(
                                      const Color.fromRGBO(58, 66, 86, 1.0)) ==
                                  Brightness.light
                              ? Colors.green
                              : Colors.white),
                      textAlign: TextAlign.center,
                    ));
                  }
                })
              ],
            )));
  }
}
