

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/utils/app_constant.dart';
import 'package:split_ride/model/payment/payment_model.dart';
import 'package:split_ride/view/widgets/widgets.dart';

class MyPaymentScreen extends StatefulWidget {
  const MyPaymentScreen({super.key});

  @override
  State<MyPaymentScreen> createState() => _MyPaymentScreenState();
}

class _MyPaymentScreenState extends State<MyPaymentScreen> {
  List<PaymentModel> _payments = [];
  bool _isLoading = false;
  double _walletBalance = 0.0;
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _itemsPerPage = 10;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchPayments();
  }

  void _onScroll() {
    // Load more when user scrolls near the end
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoadingMore) {
        _loadMorePayments();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPayments({bool isLoadMore = false}) async {
    if (_isLoading && !isLoadMore) return;
    if (_isLoadingMore && isLoadMore) return;
    if (!_hasMore && isLoadMore) return;

    if (isLoadMore) {
      setState(() {
        _isLoadingMore = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);
      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/payment/recent?page=$_currentPage&limit=$_itemsPerPage',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final List<dynamic> data = response.jsonResponse!['data'] ?? [];
        final pagination = response.jsonResponse!['pagination'] ?? {};
        final extra = response.jsonResponse!['extra'] ?? {};

        setState(() {
          if (isLoadMore) {
            _payments.addAll(data.map((item) => PaymentModel.fromJson(item)));
          } else {
            _payments = data.map((item) => PaymentModel.fromJson(item)).toList();
          }
          
          // Get wallet balance from extra
          _walletBalance = (extra['wallet'] ?? 0.0).toDouble();
          
          // Update pagination info
          _currentPage = pagination['currentPage'] ?? 1;
          _totalPages = pagination['totalPages'] ?? 1;
          _totalCount = pagination['totalCount'] ?? 0;
          _hasMore = _currentPage < _totalPages;
        });
      } else {
        if (!isLoadMore) {
          _showSnackBar(response.errorMessage ?? 'Failed to load payments');
        }
      }
    } catch (e) {
      if (!isLoadMore) {
        _showSnackBar('Error: ${e.toString()}');
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadMorePayments() async {
    if (_hasMore && !_isLoadingMore) {
      _currentPage++;
      await _fetchPayments(isLoadMore: true);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'My payment',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading && _payments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _balanceCard(),
                      SizedBox(height: 16.h),
                      // _filterRow(),
                      // SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          if (_totalCount > 0)
                            Text(
                              '$_totalCount transactions',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _currentPage = 1;
                        _payments = [];
                      });
                      await _fetchPayments();
                    },
                    child: _payments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.payment_outlined, size: 80.sp, color: Colors.grey),
                                SizedBox(height: 16.h),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: _payments.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _payments.length) {
                                // Loading indicator for more items
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: _isLoadingMore
                                        ? SizedBox(
                                            width: 24.w,
                                            height: 24.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                );
                              }
                              final payment = _payments[index];
                              return _transactionTile(payment);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  // 🔹 Balance Card
  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF45C4D9),
            Color(0xFF6B7FEC),
            Color(0xFF5c58eb),
            Color(0xFFB565D8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'My Balance',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
          ),
          Center(
            child: Text(
              '€ ${_walletBalance.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 30.sp,
              ),
            ),
          ),
          if (_totalCount > 0) ...[
            SizedBox(height: 8.h),
            Center(
              child: Text(
                '$_totalCount transactions',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 🔹 Filter Row
  Widget _filterRow() {
    return Row(
      children: [
        _chip('Filter'),
        SizedBox(width: 10.w),
        _chip('Sort'),
        const Spacer(),
        _circleIcon(Icons.download_outlined),
        SizedBox(width: 10.w),
        _circleIcon(Icons.clean_hands_outlined),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xfff2e3ff),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color:Color(0xffba63ff),
            ),
          ),
          SizedBox(width: 6.w,),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return

      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF45C4D9),

          Color(0xFF5c58eb),
          Color(0xFFB565D8),],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      );
  }

  // 🔹 Transaction Tile
  Widget _transactionTile(PaymentModel payment) {
    // Format date
    String formattedDate = '';
    if (payment.createdAt != null) {
      try {
        DateTime date = DateTime.parse(payment.createdAt!);
        formattedDate = '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year} | ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
      } catch (e) {
        formattedDate = payment.createdAt!;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          // Profile Image or Avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFFEDEAFF),
            backgroundImage: payment.userProfileImage != null &&
                    payment.userProfileImage!.isNotEmpty
                ? NetworkImage('${AppUrl.imageServeUrl}/${payment.userProfileImage}')
                : null,
            child: payment.userProfileImage == null ||
                    payment.userProfileImage!.isEmpty
                ? const Icon(Icons.person, color: Color(0xFF6B6EF9))
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.userName ?? 'Unknown User',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Booking ID ${payment.jobId ?? 'N/A'}',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '€ ${(payment.amount ?? 0.0).toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  color: Color(0xffba63ff),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                formattedDate,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
