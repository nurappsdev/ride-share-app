import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:split_ride/helpers/app_url.dart';

import '../helpers/prefs_helper.dart';
import '../utils/app_constant.dart';

/// **SocketClient Service**
///
/// A singleton service wrapper around `socket_io_client`.
/// Manages the raw WebSocket connection, including:
/// - Initialization with authentication tokens.
/// - Automatic reconnection handling.
/// - Establishing the base handshake events.
class SocketClient extends GetxService {
  static SocketClient get to => Get.find();

  IO.Socket? _socket;

  /// Returns true if the socket is currently connected to the server.
  bool get isConnected => _socket != null && _socket!.connected;

  /// Initializes the socket connection.
  ///
  /// This method forces a disconnect/reconnect cycle to ensure the
  /// authentication token is always fresh (e.g., after login/logout).
  Future<SocketClient> init() async {
    // 1. Retrieve the latest token from storage
    String freshToken = await PrefsHelper.getString(AppConstants.bearerToken);
    // debugPrint("🔌 Socket: Initializing with Token: ${freshToken.substring(0, 10)}...");

    try {
      // 2. Clean up previous connection if it exists
      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
      }

      // 3. Configure the Socket.IO instance
      _socket = IO.io(
        AppUrl.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // Force WebSocket only (no polling)
            .setExtraHeaders({"token": freshToken})
            .enableReconnection()
            .build(),
      );

      // 4. Setup internal event listeners
      _setupInternalListeners(freshToken);

      // 5. Connect
      _socket!.connect();
    } catch (e) {
      // debugPrint('❌ Socket: Init failed: $e');
    }
    return this;
  }

  void _setupInternalListeners(String token) {
    _socket?.onConnect((_) {
      // debugPrint('✅ Socket: Connected [${_socket?.id}]');
      // debugPrint("📤 Socket: Sending 'user-connected' with fresh token...");

      // Standard Handshake
      _socket?.emit('user-connected', {'token': token});
    });

    _socket?.on('user-connected-error', (data) {
      // debugPrint("❌ HANDSHAKE FAILED: $data");
    });

    _socket?.on('user-connected-success', (data) {
      // debugPrint("✅ HANDSHAKE SUCCESS! You are now online.");
    });

    _socket?.onDisconnect((_) {
      // debugPrint('⚠️ Socket: Disconnected');
    });
  }

  // ---------------------------------------------------------------------------
  // GENERIC METHODS (Wrappers)
  // ---------------------------------------------------------------------------

  /// Emits an event to the server safely.
  void emit(String event, dynamic data) {
    if (!isConnected) {
      // debugPrint("⚠️ Socket: Cannot emit '$event'. Not connected.");
      return;
    }
    _socket?.emit(event, data);
  }

  /// Registers an event listener.
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Unregisters an event listener.
  void off(String event) {
    _socket?.off(event);
  }
}