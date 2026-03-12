import 'dart:convert'; // Added for jsonEncode
import 'package:flutter/cupertino.dart';
import 'package:split_ride/helpers/logger_util.dart'; // Add your LoggerUtils import

import '../services/socket_services.dart';

/// 💬 CHAT FEATURE SOCKET LOGIC
class ChatSocketDataSource {
  final SocketClient _socketClient;

  ChatSocketDataSource(this._socketClient);

  // --- Private Event Constants ---
  static const String _eventUserConnected = 'user-connected';
  static const String _eventMessageSend = 'message-send';
  static const String _eventMessageReceive = 'message-receive';

  // --- Actions ---

  void connectUser(String userId) {
    final data = {
      "userId": userId,
      "fcmToken": ""
    };
    _socketClient.emit(_eventUserConnected, data);
  }

  void sendMessage({
    required String senderId,
    required String threadId,
    required String content,
    List<String> attachments = const [],
  }) {
    final data = {
      "senderId": senderId,
      "threadId": threadId,
      "content": content,
      "attachments": attachments,
    };

    LoggerUtils.info("📤 ChatSocket EMITTING '$_eventMessageSend': ${jsonEncode(data)}");
    _socketClient.emit(_eventMessageSend, data);
  }

  void listenToIncomingMessages(Function(dynamic) onData) {
    LoggerUtils.info("🎧 ChatSocket: REGISTERING listener for '$_eventMessageReceive'...");

    _socketClient.on(_eventMessageReceive, (data) {
      LoggerUtils.info("🔥 ChatSocket: EVENT FIRED! '$_eventMessageReceive'");

      // Print the RAW payload formatted as JSON for easy reading
      try {
        String prettyJson = jsonEncode(data);
        LoggerUtils.debug("📦 ChatSocket RAW PAYLOAD:\n$prettyJson");
      } catch (e) {
        // Fallback if it can't be JSON encoded
        LoggerUtils.debug("📦 ChatSocket RAW PAYLOAD (Unformatted): $data");
      }

      if (data == null) {
        LoggerUtils.error("❌ ChatSocket: WARNING! Payload is NULL");
        return;
      }

      try {
        onData(data);
        LoggerUtils.info("✅ ChatSocket: Data passed to Controller successfully");
      } catch (e, stack) {
        LoggerUtils.error("❌ ChatSocket: Controller crashed while processing data: $e", e, stack);
      }
    });
  }

  void stopListeningToMessages() {
    LoggerUtils.info("🔇 ChatSocket: Removing listener for '$_eventMessageReceive'");
    _socketClient.off(_eventMessageReceive);
  }
}