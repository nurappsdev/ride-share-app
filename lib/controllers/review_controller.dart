import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/services/network/network_caller.dart';

import '../model/review_model.dart';

class DriverReviewController extends GetxController {
  bool isLoading = false;
  bool isMoreLoading = false;

  List<ReviewModel> reviews = [];
  PaginationModel? pagination;
  int currentPage = 1;
  String currentDriverId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['driverId'] != null) {
      currentDriverId = Get.arguments['driverId'].toString();
      fetchReviews(isLoadMore: false);
    }
  }

  Future<void> fetchReviews({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (currentPage >= (pagination?.totalPages ?? 1)) return;
      isMoreLoading = true;
      currentPage++;
    } else {
      isLoading = true;
      currentPage = 1;
      reviews.clear();
    }
    update();

    try {
      final String token = await PrefsHelper.getString(AppConstants.bearerToken) ?? '';

      String url = "${AppUrl.baseUrl}${AppUrl.getReviewUrl(currentDriverId)}?page=$currentPage";

      final response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final reviewResponse = ReviewResponse.fromJson(response.jsonResponse!);

        if (isLoadMore) {
          reviews.addAll(reviewResponse.data ?? []);
        } else {
          reviews = reviewResponse.data ?? [];
        }

        pagination = reviewResponse.pagination;
        LoggerUtils.info("Fetched ${reviews.length} total reviews");
      } else {
        LoggerUtils.error("Failed to fetch reviews: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      LoggerUtils.error("Error fetching reviews: $e", e, stackTrace);

      if (isLoadMore && currentPage > 1) {
        currentPage--;
      }
    } finally {
      isLoading = false;
      isMoreLoading = false;
      update();
    }
  }
}