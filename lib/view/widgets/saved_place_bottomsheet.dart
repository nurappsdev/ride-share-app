
// SavedPlacesBottomSheet remains the same
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedPlacesBottomSheet extends StatefulWidget {
  const SavedPlacesBottomSheet({super.key});

  @override
  State<SavedPlacesBottomSheet> createState() => _SavedPlacesBottomSheetState();
}

class _SavedPlacesBottomSheetState extends State<SavedPlacesBottomSheet> {
  int selectedIndex = 0;

  final List<String> locations = [
    'F2 Square',
    'Location 2',
    'Location 3',
    'Location 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Choose from Saved Places',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Outfit",
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffEAF4FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          locations.length,
                              (index) => RadioListTile<int>(
                            value: index,
                            groupValue: selectedIndex,
                            activeColor: Colors.blue,
                            title: Text(
                              locations[index],
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedIndex = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _gradientButton(
                      text: 'Choose as start address',
                      onTap: () {},
                    ),
                    SizedBox(height: 12.h),
                    _gradientButton(
                      text: 'Choose as ride destination',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _gradientButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF45C4D9), Color(0xFF6B7FEC), Color(0xFFB565D8)],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: "Outfit",
          ),
        ),
      ),
    );
  }
}