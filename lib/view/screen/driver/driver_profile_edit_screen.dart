import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split_ride/utils/app_colors.dart';
import 'package:split_ride/helpers/prefs_helper.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/utils/app_constant.dart';
import '../../../helpers/secured_storage.dart';
import '../../widgets/widgets.dart';

class DriverProfileEditScreen extends StatefulWidget {
  const DriverProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<DriverProfileEditScreen> createState() => _DriverProfileEditScreenState();
}

class _DriverProfileEditScreenState extends State<DriverProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _profileImage;
  File? _cnicFront;
  File? _cnicBack;
  File? _licenseFront;
  File? _licenseBack;
  File? _carPapers;

  // Store existing image URLs from API
  String? _existingProfileImageUrl;
  String? _existingCnicFrontUrl;
  String? _existingCnicBackUrl;
  String? _existingLicenseFrontUrl;
  String? _existingLicenseBackUrl;
  List<String> _existingCarPapersUrls = [];

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';
      final response = await NetworkCaller().getRequest(
        '${AppUrl.baseUrl}/provider/profile',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess && response.jsonResponse != null) {
        final data = response.jsonResponse!['data'];
        if (data != null) {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _dobController.text = data['dateOfBirth'] ?? '';
            _addressController.text = data['address'] ?? '';

            // Store existing image URLs
            _existingProfileImageUrl = data['profileImage'] != null
                ? '${AppUrl.imageServeUrl}/${data['profileImage']}'
                : null;
            _existingCnicFrontUrl = data['cnicFront'] != null
                ? '${AppUrl.imageServeUrl}/${data['cnicFront']}'
                : null;
            _existingCnicBackUrl = data['cnicBack'] != null
                ? '${AppUrl.imageServeUrl}/${data['cnicBack']}'
                : null;
            _existingLicenseFrontUrl = data['licenseFront'] != null
                ? '${AppUrl.imageServeUrl}/${data['licenseFront']}'
                : null;
            _existingLicenseBackUrl = data['licenseBack'] != null
                ? '${AppUrl.imageServeUrl}/${data['licenseBack']}'
                : null;
            
            // carPapers is an array, get all elements
            _existingCarPapersUrls = [];
            if (data['carPapers'] != null && (data['carPapers'] as List).isNotEmpty) {
              for (var carPaper in data['carPapers']) {
                _existingCarPapersUrls.add('${AppUrl.imageServeUrl}/$carPaper');
              }
            }
          });
        }
      } else {
        _showSnackBar(response.errorMessage ?? 'Failed to load profile');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final fullPath = image.path;
      
      setState(() {
        switch (type) {
          case 'profile':
            _profileImage = File(fullPath);
            break;
          case 'cnicFront':
            _cnicFront = File(fullPath);
            break;
          case 'cnicBack':
            _cnicBack = File(fullPath);
            break;
          case 'licenseFront':
            _licenseFront = File(fullPath);
            break;
          case 'licenseBack':
            _licenseBack = File(fullPath);
            break;
          case 'carPapers':
            _carPapers = File(fullPath);
            break;
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);

      // Helper function to extract filename from URL
      String? extractFilename(String? url) {
        if (url == null || url.isEmpty) return null;
        return url.split('/').last;
      }

      // Prepare base body with text fields
      final Map<String, dynamic> body = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'dateOfBirth': _dobController.text,
        'address': _addressController.text,
      };

      // Step 1: Handle image uploads if new images selected
      print('=== Checking for new image uploads ===');
      
      String? profileImageFilename = extractFilename(_existingProfileImageUrl);
      if (_profileImage != null) {
        print('Uploading new profile image...');
        final uploaded = await _uploadImage(_profileImage!, 'profileImage');
        if (uploaded != null) {
          profileImageFilename = uploaded;
          print('Uploaded profile image: $profileImageFilename');
        }
      }
      if (profileImageFilename != null && profileImageFilename.isNotEmpty) {
        body['profileImage'] = profileImageFilename;
      }

      String? cnicFrontFilename = extractFilename(_existingCnicFrontUrl);
      if (_cnicFront != null) {
        print('Uploading new cnicFront image...');
        final uploaded = await _uploadImage(_cnicFront!, 'cnicFront');
        if (uploaded != null) {
          cnicFrontFilename = uploaded;
          print('Uploaded cnicFront: $cnicFrontFilename');
        }
      }
      if (cnicFrontFilename != null && cnicFrontFilename.isNotEmpty) {
        body['cnicFront'] = cnicFrontFilename;
      }

      String? cnicBackFilename = extractFilename(_existingCnicBackUrl);
      if (_cnicBack != null) {
        print('Uploading new cnicBack image...');
        final uploaded = await _uploadImage(_cnicBack!, 'cnicBack');
        if (uploaded != null) {
          cnicBackFilename = uploaded;
          print('Uploaded cnicBack: $cnicBackFilename');
        }
      }
      if (cnicBackFilename != null && cnicBackFilename.isNotEmpty) {
        body['cnicBack'] = cnicBackFilename;
      }

      String? licenseFrontFilename = extractFilename(_existingLicenseFrontUrl);
      if (_licenseFront != null) {
        print('Uploading new licenseFront image...');
        final uploaded = await _uploadImage(_licenseFront!, 'licenseFront');
        if (uploaded != null) {
          licenseFrontFilename = uploaded;
          print('Uploaded licenseFront: $licenseFrontFilename');
        }
      }
      if (licenseFrontFilename != null && licenseFrontFilename.isNotEmpty) {
        body['licenseFront'] = licenseFrontFilename;
      }

      String? licenseBackFilename = extractFilename(_existingLicenseBackUrl);
      if (_licenseBack != null) {
        print('Uploading new licenseBack image...');
        final uploaded = await _uploadImage(_licenseBack!, 'licenseBack');
        if (uploaded != null) {
          licenseBackFilename = uploaded;
          print('Uploaded licenseBack: $licenseBackFilename');
        }
      }
      if (licenseBackFilename != null && licenseBackFilename.isNotEmpty) {
        body['licenseBack'] = licenseBackFilename;
      }

      // Car papers - handle array
      List<String> carPapers = [];
      if (_carPapers != null) {
        print('Uploading new carPapers image...');
        final uploaded = await _uploadImage(_carPapers!, 'carPapers');
        if (uploaded != null) {
          carPapers.add(uploaded);
          print('Uploaded carPapers: $uploaded');
        }
      } else if (_existingCarPapersUrls.isNotEmpty) {
        for (var url in _existingCarPapersUrls) {
          final filename = extractFilename(url);
          if (filename != null && filename.isNotEmpty) {
            carPapers.add(filename);
          }
        }
      }
      if (carPapers.isNotEmpty) {
        body['carPapers'] = carPapers;
      }

      print('=== Image uploads complete ===');

      // Step 2: Send PUT request with all data
      print('=== Profile Update Request ===');
      print('Body: $body');
      print('=============================');

      final response = await NetworkCaller().putRequest(
        '${AppUrl.baseUrl}/provider/profile',
        body: body,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess) {
        _showSnackBar('Profile updated successfully!');
        // Clear selected files
        setState(() {
          _profileImage = null;
          _cnicFront = null;
          _cnicBack = null;
          _licenseFront = null;
          _licenseBack = null;
          _carPapers = null;
        });
        // Refresh profile data
        await _fetchProfileData();
      } else {
        _showSnackBar(response.errorMessage ?? 'Failed to update profile');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Upload image and return server filename
  Future<String?> _uploadImage(File file, String fieldName) async {
    try {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);
      
      print('Uploading $fieldName to ${AppUrl.imageUploadUrl}');
      
      final response = await NetworkCaller().multipartPostRequest(
        AppUrl.imageUploadUrl,
        files: {'file': file},
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Upload response for $fieldName: ${response.jsonResponse}');

      if (response.isSuccess && response.jsonResponse != null) {
        // Try different possible response formats
        final data = response.jsonResponse!;
        final filename = data['filename'] ??
            data['fileName'] ??
            data['name'] ??
            data['data']?['filename'] ??
            data['data']?['fileName'] ??
            data['data']?['name'] ??
            '';
        
        if (filename.isNotEmpty) {
          print('Successfully uploaded $fieldName: $filename');
          return filename;
        }
      }
      
      print('Failed to upload $fieldName: ${response.errorMessage}');
      return null;
    } catch (e) {
      print('Upload error for $fieldName: $e');
      return null;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  : _existingProfileImageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(_existingProfileImageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                            child: _profileImage == null && _existingProfileImageUrl == null
                                ? Center(
                                    child: Text(
                                      _getInitials(),
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
                            existingImageUrl: _existingCnicFrontUrl,
                            label: 'Front',
                            onTap: () => _pickImage('cnicFront'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildDocumentCard(
                            image: _cnicBack,
                            existingImageUrl: _existingCnicBackUrl,
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
                            existingImageUrl: _existingLicenseFrontUrl,
                            label: 'Front',
                            onTap: () => _pickImage('licenseFront'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildDocumentCard(
                            image: _licenseBack,
                            existingImageUrl: _existingLicenseBackUrl,
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
                      existingImageUrl: _existingCarPapersUrls.isNotEmpty 
                          ? _existingCarPapersUrls.first 
                          : null,
                      onTap: () => _pickImage('carPapers'),
                    ),
                    SizedBox(height: 20.h),
                    CustomButtonCommon(
                      title: _isSaving ? 'Saving...' : 'Save Changes',
                      onpress: _saveChanges,
                      useGradient: true,
                      loading: _isSaving,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
    );
  }

  String _getInitials() {
    if (_nameController.text.isEmpty) {
      return 'DR';
    }
    final names = _nameController.text.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return 'DR';
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
    required String? existingImageUrl,
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
                  : existingImageUrl != null
                      ? Image.network(
                          existingImageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(Icons.insert_drive_file_outlined, size: 40.sp, color: Colors.grey),
                              ),
                            );
                          },
                        )
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
    required String? existingImageUrl,
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
                  : existingImageUrl != null
                      ? Image.network(
                          existingImageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(Icons.insert_drive_file_outlined, size: 48.sp, color: Colors.grey),
                              ),
                            );
                          },
                        )
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