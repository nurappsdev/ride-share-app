import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/utils/app_colors.dart';
import '../../widgets/widgets.dart';

class DriverProfileEditScreen extends StatefulWidget {
  const DriverProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<DriverProfileEditScreen> createState() => _DriverProfileEditScreenState();
}

class _DriverProfileEditScreenState extends State<DriverProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Kimmy Natasa');
  final TextEditingController _phoneController = TextEditingController(text: '52 304 0829190');
  final TextEditingController _dobController = TextEditingController(text: '26th November, 2001');
  final TextEditingController _addressController = TextEditingController(text: 'Main Square Lt. Block, NYC');

  File? _profileImage;
  File? _cnicFront;
  File? _cnicBack;
  File? _licenseFront;
  File? _licenseBack;
  File? _carPapers;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (type) {
          case 'profile':
            _profileImage = File(image.path);
            break;
          case 'cnicFront':
            _cnicFront = File(image.path);
            break;
          case 'cnicBack':
            _cnicBack = File(image.path);
            break;
          case 'licenseFront':
            _licenseFront = File(image.path);
            break;
          case 'licenseBack':
            _licenseBack = File(image.path);
            break;
          case 'carPapers':
            _carPapers = File(image.path);
            break;
        }
      });
    }
  }

  void _saveChanges() {
    // Save data logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        animateColor: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w600, fontFamily: "Outfit"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110.w,
                      height: 110.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.grey, Colors.blueGrey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        image: _profileImage != null
                            ? DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: _profileImage == null
                          ? Center(
                        child: Text(
                          'KN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Outfit",
                          ),
                        ),
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0.h,
                      right: 0.w,
                      child: GestureDetector(
                        onTap: () => _pickImage('profile'),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 18.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Full Name
              _buildLabel('Full Name'),
              _buildTextField(
                controller: _nameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.h),

              // Phone Number
              _buildLabel('Phone Number'),
              _buildTextField(
                controller: _phoneController,
                icon: Icons.phone_outlined,
              ),
              SizedBox(height: 16.h),

              // Date of Birth
              _buildLabel('Date of Birth'),
              _buildTextField(
                controller: _dobController,
                icon: Icons.calendar_today_outlined,
              ),
              SizedBox(height: 16.h),

              // Address
              _buildLabel('Address'),
              _buildTextField(
                controller: _addressController,
                icon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16.h),

              // CNIC
              _buildLabel('CNIC'),
              Row(
                children: [
                  Expanded(
                    child: _buildDocumentCard(
                      image: _cnicFront,
                      label: 'Front',
                      onTap: () => _pickImage('cnicFront'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDocumentCard(
                      image: _cnicBack,
                      label: 'Back',
                      onTap: () => _pickImage('cnicBack'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Driving License
              _buildLabel('Driving License'),
              Row(
                children: [
                  Expanded(
                    child: _buildDocumentCard(
                      image: _licenseFront,
                      label: 'Front',
                      onTap: () => _pickImage('licenseFront'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDocumentCard(
                      image: _licenseBack,
                      label: 'Back',
                      onTap: () => _pickImage('licenseBack'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Car Papers
              _buildLabel('Car Papers'),
              _buildFullDocumentCard(
                image: _carPapers,
                onTap: () => _pickImage('carPapers'),
              ),
              SizedBox(height: 20.h),
              CustomButtonCommon(title:      'Save Changes', onpress: _saveChanges,useGradient: true,),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
 //     bottomSheet:CustomButtonCommon(title:      'Save Changes', onpress: (){},useGradient: true,)
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontFamily: "Outfit",
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return CustomTextField(
      controller: controller,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: AppColors.primary3rdColor, size: 22.sp),
      ),
      // contentPaddingHorizontal: 16.w,
      // contentPaddingVertical: 16.h,
      // borderRadio: 12.r,
      hinTextSize: 14.sp,
      borderColor: Colors.grey.shade300,
    );
  }

  Widget _buildDocumentCard({
    required File? image,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.r,
              offset: Offset(0.w, 2.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: image != null
                  ? Image.file(image, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                  : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.insert_drive_file_outlined, size: 40.sp, color: Colors.grey),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, size: 18.sp, color: Colors.black87),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp, fontFamily: "Outfit"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullDocumentCard({
    required File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.r,
              offset: Offset(0.w, 2.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: image != null
                  ? Image.file(image, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                  : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.insert_drive_file_outlined, size: 48.sp, color: Colors.grey),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, size: 22.sp, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}