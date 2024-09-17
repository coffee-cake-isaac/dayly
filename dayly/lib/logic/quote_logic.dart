import 'dart:convert';

import 'package:dayly/models/json_quote.dart';
import 'package:dayly/models/quote.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QuoteLogic {
  var quote = Quote(author: RxString(""), message: RxString(""));

  QuoteLogic() {
    initialize();
  }

  Future<void> initialize() async {
    await getQuote();
  }

  Future<void> getQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/today'));

    // Parse the response
    var parsedQuote = JsonQuote.fromJsonList(jsonDecode(response.body));

    // Update the quote object with the API data
    quote.author.value = parsedQuote.first.a;
    quote.message.value = parsedQuote.first.q;
  }
}
