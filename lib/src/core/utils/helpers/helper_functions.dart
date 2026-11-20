import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';

class HelperFunctions {

  static void customAlert({required BuildContext sContext, required String title, required String message}){
    showDialog(
      context: sContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.okLabel),
            )
          ],
        );
      },
    );
  }

  static void pushNavigateToScreen({required BuildContext context, required Widget screen}){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void pushAndReplaceNavigateToScreen({required BuildContext context, required Widget screen}){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength){
    if(text.length <= maxLength){
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double pixelRatio(BuildContext context){
    return MediaQuery.of(context).devicePixelRatio;
  }


  static double statusBarHeight(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }

  static double bottomNavBarHeight(BuildContext context){
    return kBottomNavigationBarHeight;
  }

  static double appBarHeight(BuildContext context){
    return kToolbarHeight;
  }

  static double keyBoardHeight(BuildContext context){
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom;
  }

  static Future<bool> isKeyboardVisible(BuildContext context) async{
    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  static Future<bool> isPhysicalDevice(BuildContext context) async{
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static Future<bool> hasInternetConnection() async{
    try{
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_){
      return false;
    }
  }

  static String formatCurrency(double? amount) {
    return "Rs. ${(amount ?? 0.0).toStringAsFixed(2)}";
  }

  static String? formatValidity(double? validity, String? period){
    int count = (validity ?? 0.0).toInt();

    if(count == 0) return null;

    return "$count $period${count >1 ? 's' : ''}";
  }

  static bool isIOS(){
    return Platform.isIOS;
  }

  static bool isAndroid(){
    return Platform.isAndroid;
  }

  static List<T> removeDuplicates<T>(List<T> list){
    return list.toSet().toList();
  }

  static String getInitials(String text) {
    if (text.isEmpty) return '-';

    final words = text.trim().split(RegExp(r'\s+'));

    if (words.isEmpty) return '-';

    if (words.length >= 2) {
      return (words[0].isNotEmpty ? words[0][0] : '') +
          (words[1].isNotEmpty ? words[1][0] : '');
    }

    return words[0].isNotEmpty ? words[0][0] : '';
  }

  static String maskPhoneNumber(String phone) {
    // Strip any whitespace or special characters first if needed
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

    if (cleanPhone.length < 5) return phone; // Fallback for unusually short input

    final start = cleanPhone.substring(0, 3);
    final end = cleanPhone.substring(cleanPhone.length - 2);
    const middleMask = '*******'; // 7 asterisks

    return '$start$middleMask$end';
  }

  static String maskedNumber(String accountNumber, {bool showFullNumber = false}) {
    if (showFullNumber || accountNumber.length <= 4) {
      return accountNumber;
    }
    final last4 = accountNumber.substring(accountNumber.length - 4);
    return '•••• •••• $last4';
  }



  ///DATE FORMATS--------------------------------------------------->
  // Formats a date string (e.g., "2026-07-20 05:03:03.000") into relative time strings.
  static String formatRelativeDate(dynamic dateInput) {
    if (dateInput == null) return '';

    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      date = DateTime.tryParse(dateInput);
    }

    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    // Future dates safeguard
    if (difference.isNegative) {
      return 'Just now';
    }

    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    if (seconds < 60) {
      return 'Just now';
    } else if (minutes < 60) {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (hours < 24 && _isSameDay(now, date)) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (_isSameDay(now, date)) {
      return 'Today';
    } else if (_isYesterday(now, date)) {
      return 'Yesterday';
    } else if (days <= 30) {
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      final months = (days / 30).floor();
      if (months < 12) {
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (days / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    }
  }

  // Helper to check if two dates are on the same calendar day
  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Helper to check if a date was calendar yesterday
  static bool _isYesterday(DateTime now, DateTime date) {
    final yesterday = now.subtract(const Duration(days: 1));
    return _isSameDay(yesterday, date);
  }

  static String getToday() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;

    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return  days[weekday - 1].toLowerCase();
  }

  static String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy_MM_dd_HH_mm_ss');
    return formatter.format(now);
  }

  static String convertToAMPM(String time) {
    DateTime dateTime = DateFormat('HH:mm').parse(time);
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime, {bool withTime = true}) {
    // 'MMM dd, yyyy, hh:mm a' -> Oct 02, 2026, 01:16 PM
    if(withTime){
      return DateFormat('MMM dd, yyyy, hh:mm a').format(dateTime);
    }
    return DateFormat('MMM dd, yyyy').format(dateTime);

  }

  static String calculateRemainingTime(DateTime futureDate) {
    final now = DateTime.now();
    final difference = futureDate.difference(now);

    // If the date has already passed
    if (difference.isNegative) return "0 days remaining";


    // 1. Days and remaining hours (e.g., 5 days and 14 hours)
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    String dayText = "";
    String hourText = "";
    String minuteText = "";

    if(days > 0){
      dayText = "$days days ";
    }
    if(hours > 0){
      hourText = "$hours hours ";
    }
    if(minutes > 0){
      minuteText = "$minutes minutes ";
    }

    String finalText = 'remaining';
    return '$dayText$hourText$minuteText$finalText';

  }

  static bool isExpired({required DateTime expDate, DateTime? customNow}) {
    final now = customNow ?? DateTime.now();
    return now.isAfter(expDate);
  }

  static DateTime calculateExpiryDate(DateTime activatedDate, double? validity, String? validityPeriod) {
    if (validity == null || validity <= 0 || validityPeriod == null || validityPeriod.isEmpty) {
      return activatedDate;
    }

    final normalizedPeriod = validityPeriod.trim().toLowerCase();
    final durationValue = validity;

    if (normalizedPeriod == 'day' || normalizedPeriod == 'days') {
      return activatedDate.add(Duration(hours: (durationValue * 24).round()));
    }

    if (normalizedPeriod == 'hour' || normalizedPeriod == 'hours') {
      return activatedDate.add(Duration(minutes: (durationValue * 60).round()));
    }

    return activatedDate;
  }

  static bool isTimeDifferenceMoreThan(DateTime dateTime1, DateTime dateTime2, {int minutesThreshold = 5}) {
    Duration difference = dateTime1.difference(dateTime2);
    int differenceInMinutes = difference.inMinutes.abs();
    return differenceInMinutes > minutesThreshold;
  }

  // static Future<String?> getFCMToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   return token;
  // }

  static List<String> makeEnumList<T extends Enum>(Iterable<T> enumValues) {
    return enumValues.map((v) => v.name).toList();
  }

  static List<String> removeUnderscore(List<String> list) {

    return list.map((v) => v.replaceAll("_", " ")).toList();
  }

  static String invoiceNumber(int n){
    return 'W-${n.toString().padLeft(4, '0')}';
  }
}
