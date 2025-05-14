import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MessageStorage {
  static Future<void> cacheMessages(
      String chatId, List<dynamic> messagesJson) async {
    final prefShare = await SharedPreferences.getInstance();
    await prefShare.setString('messages_$chatId', jsonEncode(messagesJson));
  }

  static Future<List<dynamic>> getCachedMessages(String chatId) async {
    final prefShare = await SharedPreferences.getInstance();
    final raw = prefShare.getString('messages_$chatId');
    if (raw == null) return [];
    return jsonDecode(raw);
  }

  static Future<void> clearMessages(String chatId) async {
    final prefShare = await SharedPreferences.getInstance();
    await prefShare.remove('messages_$chatId');
  }
}
