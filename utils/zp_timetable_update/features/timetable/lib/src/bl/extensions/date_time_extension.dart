extension DateTimeExtensions on DateTime {
  DateTime asDate() => DateTime(this.year, this.month, this.day);
}