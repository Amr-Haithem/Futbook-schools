import 'dart:io';

import 'package:http/http.dart';

class Date {
  static const Map<String, int> _monthNames = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "May": 5,
    "Jun": 6,
    "Jul": 7,
    "Aug": 8,
    "Sep": 9,
    "Oct": 10,
    "Nov": 11,
    "Dec": 12,
  };

  Future<DateTime> fetchDate() async {
    try {
      final url = Uri.parse('https://google.com/%27');
      final response = await get(url);

      print(response.contentLength);
      print(response.headers['date']);

      final List<String> splitResponse = response.headers['date'].split(' ');
      final List<int> time =
          splitResponse[4].split(':').map((e) => int.parse(e)).toList();

      DateTime date = DateTime(
        int.parse(splitResponse[3]),
        _monthNames[splitResponse[2]],
        int.parse(splitResponse[1]),
        time[0],
        time[1],
        time[2],
      );

      date = date.add(const Duration(
        hours: 2,
      ));
      return date;
    } on SocketException {
      return Future.error("مشكلة في الاتصال بالانترنت.اتصل و اعد المحاولة");
    } on HttpException {
      return Future.error("مشكلة في تحميل تاريخ اليوم");
    } on FormatException {
      return Future.error("مشكلة في تحميل تاريخ اليوم");
    } catch (e) {
      return Future.error("مشكلة في تحميل تاريخ اليوم");
    }
  }
}
