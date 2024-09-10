import 'dart:convert';

class JsonQuote {
  final String q;
  final String a;
  final String h;

  JsonQuote({
    required this.q,
    required this.a,
    required this.h,
  });

  // Factory method to create a single JsonQuote object from a Map
  factory JsonQuote.fromJson(Map<String, dynamic> json) {
    return JsonQuote(
      q: json['q'],
      a: json['a'],
      h: json['h'],
    );
  }

  // Static method to handle a list of JsonQuote objects from a List
  static List<JsonQuote> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => JsonQuote.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'a': a,
      'h': h,
    };
  }
}
