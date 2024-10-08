import 'dart:convert';

import 'package:flutter/material.dart';
import 'json_quote.dart';
import 'package:http/http.dart' as http;

class Quote extends ChangeNotifier {
  var author = "";
  var message = "";
  var isLoading = true;

  Quote() {
    initialize();
  }

  Future<void> initialize() async {
    await getQuote();
  }

  Future<void> getQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/today'));

    var parsedQuote = JsonQuote.fromJsonList(jsonDecode(response.body));

    author = "- ${parsedQuote.first.a}";
    message = parsedQuote.first.q;
    isLoading = false;
    notifyListeners();
  }
}
