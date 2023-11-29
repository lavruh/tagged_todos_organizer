extension CompareDateTo on DateTime {
  int compareDateTo(DateTime b) {
    if (millisecondsSinceEpoch == b.millisecondsSinceEpoch) return 0;
    if (millisecondsSinceEpoch > b.millisecondsSinceEpoch) return 1;
    if (millisecondsSinceEpoch < b.millisecondsSinceEpoch) return -1;
    return 0;
  }
}
