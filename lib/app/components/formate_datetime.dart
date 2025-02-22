import 'package:intl/intl.dart';

String formatDateTime(String? isoString) {
  if (isoString == null || isoString.isEmpty) return '';

  DateTime dateTime = DateTime.parse(isoString).toLocal();
  String formattedDate = DateFormat('d MMM, h:mm a').format(dateTime);

  // Convert "AM" and "PM" to lowercase and adjust formatting
  formattedDate = formattedDate.replaceAll("AM", "am").replaceAll("PM", "pm");

  return formattedDate;
}
