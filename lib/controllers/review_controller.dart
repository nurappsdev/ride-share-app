import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/services/api_client.dart';
import 'package:split_ride/helpers/logger_util.dart';

import '../model/review_model.dart';
// import 'package:split_ride/models/review_model.dart'; // Import your model

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
      // Prevent loading if we already reached the last page
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
      // Adding ?page= query parameter for pagination
      String url = "${AppUrl.getReviewUrl(currentDriverId)}?page=$currentPage";
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        final reviewResponse = ReviewResponse.fromJson(response.body);

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
    } finally {
      isLoading = false;
      isMoreLoading = false;
      update();
    }
  }
}