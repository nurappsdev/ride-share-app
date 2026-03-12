import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/helpers/app_url.dart';

import '../../datasource/chat_socket_datasource.dart';
import '../../model/message/message_model.dart';

// Import your models and data source here
// import 'package:split_ride/models/message_model.dart';
// import 'package:split_ride/datasource/chat_socket_datasource.dart';

class ChatDriverController extends GetxController {
  final ChatSocketDataSource socketDataSource = Get.find<ChatSocketDataSource>();

  // --- State Variables ---
  List<MessageModel> messages = [];
  bool showSendButton = false;

  // --- Image Handling State ---
  File? selectedImage;
  bool isUploadingImage = false;
  final ImagePicker _picker = ImagePicker();

  // --- Metadata ---
  String threadId = '';
  String driverName = '';
  String driverPhone = '';
  String driverEmail = '';
  String otherUserId = '';
  String currentUserId = '';

  // --- Pagination State ---
  bool isInitialLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  int _page = 1;
  PaginationModel? pagination;

  // --- UI Controllers ---
  late TextEditingController messageController;
  late FocusNode focusNode;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _handleArguments();
    _initializeUserAndSocket();
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    socketDataSource.stopListeningToMessages();
    super.onClose();
  }

  void _initializeControllers() {
    messageController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();

    messageController.addListener(_updateSendButtonState);
    scrollController.addListener(_onScroll);
  }

  void _updateSendButtonState() {
    final shouldShow = messageController.text.trim().isNotEmpty || selectedImage != null;
    if (showSendButton != shouldShow) {
      showSendButton = shouldShow;
      update();
    }
  }

  void _handleArguments() {
    if (Get.arguments != null) {
      otherUserId = Get.arguments['otherUserId']?.toString() ?? '';
      driverName = Get.arguments['driverName']?.toString() ?? 'Driver';
      driverPhone = Get.arguments['driverPhone']?.toString() ?? '--';
      driverEmail = Get.arguments['driverEmail']?.toString() ?? '--';

      update();

      if (otherUserId.isNotEmpty) {
        getMessages();
      } else {
        LoggerUtils.error("No otherUserId provided for chat!");
      }
    }
  }

  Future<void> _initializeUserAndSocket() async {
    currentUserId = await PrefsHelper.getString(AppConstants.userId) ?? '';
    socketDataSource.listenToIncomingMessages(_onMessageReceived);
  }

  // ===========================================================================
  // IMAGE PICKING & UPLOADING LOGIC
  // ===========================================================================

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        selectedImage = File(image.path);
        _updateSendButtonState();
      }
    } catch (e) {
      LoggerUtils.error("Failed to pick image: $e");
    }
  }

  void clearSelectedImage() {
    selectedImage = null;
    _updateSendButtonState();
  }

  Future<String?> uploadImage(File file) async {
    try {
      String token = await PrefsHelper.getString(AppConstants.bearerToken) ?? '';

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AppUrl.baseUrl}/upload')
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['path']; // Extract path from backend
      } else {
        LoggerUtils.error("Image upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      LoggerUtils.error("Image upload exception: $e");
      return null;
    }
  }

  // ===========================================================================
  // SEND MESSAGE LOGIC
  // ===========================================================================

  void onTapSendMessageBtn() async {
    final String content = messageController.text.trim();

    if (content.isEmpty && selectedImage == null) return;
    if (threadId.isEmpty) {
      LoggerUtils.error("Cannot send: threadId is empty!");
      return;
    }

    final String tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    File? imageToSend = selectedImage;

    // 1. Optimistic Update
    _insertOptimisticMessage(tempId, content, localImage: imageToSend);

    // 2. Reset UI state immediately
    messageController.clear();
    selectedImage = null;
    showSendButton = false;
    update();
    _scrollToBottom();

    List<String> uploadedAttachments = [];

    // 3. Upload Image (If exists)
    if (imageToSend != null) {
      String? serverPath = await uploadImage(imageToSend);
      if (serverPath != null) {
        uploadedAttachments.add(serverPath);
      } else {
        LoggerUtils.error("Image upload failed. Sending text only.");
      }
    }

    try {
      // 4. Emit via Socket
      socketDataSource.sendMessage(
        senderId: currentUserId,
        threadId: threadId,
        content: content,
        attachments: uploadedAttachments,
      );
    } catch (e) {
      LoggerUtils.error("Send Message Exception: $e");
    }
  }

  void _insertOptimisticMessage(String tempId, String content, {File? localImage}) {
    List<String> tempAttachments = localImage != null ? [localImage.path] : [];

    final tempMessage = MessageModel(
      id: tempId,
      senderId: currentUserId,
      threadId: threadId,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      attachments: tempAttachments,
    );
    messages.insert(0, tempMessage);
  }

  // ===========================================================================
  // SOCKET LISTENERS
  // ===========================================================================

  void _onMessageReceived(dynamic data) {
    try {
      final newMessage = MessageModel.fromJson(data);

      if (newMessage.threadId != threadId) return;

      if (newMessage.senderId != currentUserId) {
        messages.insert(0, newMessage);
      } else {
        _mergeOptimisticMessage(newMessage);
      }

      update();
      _scrollToBottom();
    } catch (e, stack) {
      LoggerUtils.error("Error parsing incoming socket message: $e", e, stack);
    }
  }

  void _mergeOptimisticMessage(MessageModel serverMessage) {
    final index = messages.indexWhere(
            (m) => m.content == serverMessage.content && m.senderId == currentUserId
    );

    if (index != -1) {
      messages[index] = serverMessage;
    } else {
      messages.insert(0, serverMessage);
    }
  }

  // ===========================================================================
  // PAGINATION LOGIC
  // ===========================================================================

  void _scrollToBottom() {
    if (scrollController.hasClients && scrollController.position.pixels < 300) {
      scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
      if (hasMore && !isLoadingMore) {
        getMessages(isPagination: true);
      }
    }
  }

  Future<void> getMessages({bool isPagination = false}) async {
    if (isPagination && (!hasMore || isLoadingMore)) return;

    if (isPagination) {
      isLoadingMore = true;
    } else {
      isInitialLoading = true;
      _page = 1;
      hasMore = true;
      messages.clear();
    }
    update();

    try {
      String url = "/message/$otherUserId?page=$_page&limit=20";
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        final msgResponse = MessageResponse.fromJson(response.body);

        if (msgResponse.extra?.threadId != null) {
          threadId = msgResponse.extra!.threadId!;

          // NOTE: If your backend requires you to join a room to listen, do it here:
          // socketDataSource.joinRoom(threadId);
        }

        pagination = msgResponse.pagination;
        if (_page >= (pagination?.totalPages ?? 1)) {
          hasMore = false;
        } else {
          _page++;
        }

        if (isPagination) {
          messages.addAll(msgResponse.data ?? []);
        } else {
          messages = msgResponse.data ?? [];
        }
      }
    } catch (e, stack) {
      LoggerUtils.error("Error loading API messages: $e", e, stack);
    } finally {
      isInitialLoading = false;
      isLoadingMore = false;
      update();
    }
  }
}