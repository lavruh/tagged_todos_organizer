extension CompareDateTo on DateTime {
  int compareDateTo(DateTime b) {
    if (millisecondsSinceEpoch == b.millisecondsSinceEpoch) return 0;
    if (millisecondsSinceEpoch > b.millisecondsSinceEpoch) return 1;
    if (millisecondsSinceEpoch < b.millisecondsSinceEpoch) return -1;
    return 0;
  }
}


extension IsSameDate on DateTime {
  bool isSameDate(DateTime b) {
    return year == b.year && month == b.month && day == b.day;
  }
}