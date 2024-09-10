class RepeatFrequency {
  final int interval;
  final RepeatUnit unit;

  RepeatFrequency({required this.interval, required this.unit});
}

enum RepeatUnit {
  minutes,
  hours,
  days,
  weeks,
  months,
  years,
}
