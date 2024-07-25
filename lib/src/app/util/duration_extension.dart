extension DurationToText on Duration {
  String get toText {
    // Check if the duration is negative
    final isNegative = this.isNegative;

    // Take the absolute value of the duration to calculate hours and minutes
    final absDuration = abs();
    final hours = absDuration.inHours;
    final minutes = absDuration.inMinutes.remainder(60);

    // Format the hours and minutes as "HH:MM"
    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');

    // Concatenate the formatted hours and minutes with a sign "-" if necessary
    final sign = isNegative ? '-' : '';
    return '$sign$formattedHours:$formattedMinutes';
  }
}
