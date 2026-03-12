import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/model/notification_model.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';

class NotificationController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  
  /// Notification list
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  
  /// Pagination
  int currentPage = 1;
  static const int itemsPerPage = 15;
  int totalPages = 1;
  int totalCount = 0;
  
  /// Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    LoggerUtils.debug('NotificationController initialized');
    _setupScrollListener();
    fetchNotifications();
  }

  /// Setup scroll listener for infinite scroll
  void _setupScrollListener() {
    scrollController.addListener(() {
      // Check if user scrolled to bottom (with 100px threshold)
      if (scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent - 100) {
        LoggerUtils.debug(
          'Scroll triggered: ${scrollController.position.pixels} / ${scrollController.position.maxScrollExtent}, HasMore: $hasMoreData.value, CurrentPage: $currentPage, TotalPages: $totalPages',
        );
        _loadMore();
      }
    });
  }

  /// Fetch notifications from backend
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        notifications.clear();
      }
      
      isLoading.value = true;
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';

      // Request 15 items per page
      final String url = '${AppUrl.notification}?page=$currentPage&limit=15&perPage=15';
      LoggerUtils.debug('Fetching notifications from: $url');

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      LoggerUtils.debug('API Response Status: ${response.isSuccess}');
      LoggerUtils.debug('API Response: ${response.jsonResponse}');
      
      if (response.isSuccess) {
        final List<dynamic> data = response.jsonResponse?['data'] ?? [];
        final pagination = response.jsonResponse?['pagination'] ?? {};
        
        // Update pagination info
        totalPages = pagination['totalPages'] ?? 1;
        totalCount = pagination['totalCount'] ?? 0;
        currentPage = pagination['currentPage'] ?? 1;
        final itemsPerPage = pagination['itemsPerPage'] ?? 0;
        
        LoggerUtils.debug(
          'Pagination Info - Page: $currentPage, Pages: $totalPages, Total: $totalCount, PerPage: $itemsPerPage, Received: ${data.length}',
        );
        
        // Parse notifications
        final newNotifications = data
            .map((item) => NotificationModel.fromJson(item))
            .toList();
        
        if (isRefresh) {
          notifications.clear();
        }
        
        notifications.addAll(newNotifications);
        
        // Check if there's more data
        hasMoreData.value = currentPage < totalPages;
        
        LoggerUtils.debug(
          'Notifications fetched: ${notifications.length} / $totalCount (Page $currentPage/$totalPages), HasMore: ${hasMoreData.value}',
        );
      } else {
        LoggerUtils.error(
          'Failed to fetch notifications: ${response.jsonResponse?['message']}',
        );
        if (notifications.isEmpty) {
          hasMoreData.value = false;
        }
      }
    } catch (e) {
      LoggerUtils.debug('Error fetching notifications: $e');
      if (notifications.isEmpty) {
        hasMoreData.value = false;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more notifications (pagination)
  Future<void> _loadMore() async {
    // Don't load if already loading or no more data
    if (isLoadingMore.value || !hasMoreData.value || isLoading.value) {
      LoggerUtils.debug('Load more skipped: isLoadingMore=$isLoadingMore.value, hasMoreData=$hasMoreData.value, isLoading=$isLoading.value');
      return;
    }
    
    // Check if we've reached the end
    if (currentPage >= totalPages) {
      hasMoreData.value = false;
      LoggerUtils.debug('Load more skipped: Already at last page');
      return;
    }
    
    try {
      isLoadingMore.value = true;
      currentPage++;
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';

      // Request 15 items per page
      final String url = '${AppUrl.notification}?page=$currentPage&limit=15&perPage=15';
      LoggerUtils.debug('Loading more from: $url');

      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response.isSuccess) {
        final List<dynamic> data = response.jsonResponse?['data'] ?? [];
        final pagination = response.jsonResponse?['pagination'] ?? {};
        
        // Update pagination info
        totalPages = pagination['totalPages'] ?? 1;
        currentPage = pagination['currentPage'] ?? currentPage;
        final itemsPerPage = pagination['itemsPerPage'] ?? 0;
        
        LoggerUtils.debug(
          'Load More - Page: $currentPage, Pages: $totalPages, PerPage: $itemsPerPage, Received: ${data.length}',
        );
        
        // Parse and add notifications
        final newNotifications = data
            .map((item) => NotificationModel.fromJson(item))
            .toList();
        
        notifications.addAll(newNotifications);
        
        // Check if there's more data
        hasMoreData.value = currentPage < totalPages;
        
        LoggerUtils.debug(
          'More notifications loaded: ${notifications.length} total (Page $currentPage/$totalPages), HasMore: ${hasMoreData.value}',
        );
      } else {
        LoggerUtils.error('Failed to load more notifications');
        hasMoreData.value = false;
      }
    } catch (e) {
      LoggerUtils.debug('Error loading more notifications: $e');
      hasMoreData.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Pull to refresh
  Future<void> refreshNotifications() async {
    await fetchNotifications(isRefresh: true);
  }

  /// Mark notification as viewed (optional - if API supports)
  Future<void> markAsViewed(String notificationId) async {
    try {
      // You can implement this if your API supports marking as viewed
      // final String token = await SecureStorageService().read(
      //   AppConstants.accessToken,
      // ) ?? '';
      
      // final NetworkResponse response = await NetworkCaller().putRequest(
      //   '/notification/$notificationId/view',
      //   headers: {'Authorization': 'Bearer $token'},
      //   body: {'viewStatus': true},
      // );
      
      // if (response.isSuccess) {
      //   // Update local state
      //   final index = notifications.indexWhere(
      //     (n) => n.id == notificationId,
      //   );
      //   if (index != -1) {
      //     // Update the notification
      //   }
      // }
    } catch (e) {
      LoggerUtils.debug('Error marking notification as viewed: $e');
    }
  }

  /// Get notification icon based on type
  String getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'payment':
        return 'payment';
      case 'ride':
        return 'ride';
      case 'booking':
        return 'booking';
      default:
        return 'notification';
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}