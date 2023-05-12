extension CompareDateTo on DateTime {
  int compareDateTo(DateTime b) {
    if (year > b.year || month > b.month || day > b.day) return 1;
    if (year < b.year || month < b.month || day < b.day) return -1;
    if (year == b.year || month == b.month || day == b.day) return 0;
    return 0;
  }
}
