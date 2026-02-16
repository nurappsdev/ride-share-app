// ============================================
// File 1: controllers/document_upload_controller.dart
// ============================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:split_ride/helpers/app_url.dart';
import 'dart:convert';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/view/widgets/toast_manager.dart';

class DriverDocumentUploadController extends GetxController {
  // Observable files
  final Rx<File?> cnicFront = Rx<File?>(null);
  final Rx<File?> cnicBack = Rx<File?>(null);
  final Rx<File?> licenseFront = Rx<File?>(null);
  final Rx<File?> licenseBack = Rx<File?>(null);
  final RxList<File> carPapers = <File>[].obs;

  // Observable URLs after upload
  final RxString cnicFrontUrl = ''.obs;
  final RxString cnicBackUrl = ''.obs;
  final RxString licenseFrontUrl = ''.obs;
  final RxString licenseBackUrl = ''.obs;
  final RxList<String> carPapersUrls = <String>[].obs;

  // Loading states
  final RxBool isUploading = false.obs;
  final RxMap<String, bool> uploadingStates = <String, bool>{}.obs;

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  Future<void> pickImage(String type, {ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        final File file = File(image.path);

        // Update UI immediately
        switch (type) {
          case 'cnicFront':
            cnicFront.value = file;
            break;
          case 'cnicBack':
            cnicBack.value = file;
            break;
          case 'licenseFront':
            licenseFront.value = file;
            break;
          case 'licenseBack':
            licenseBack.value = file;
            break;
          case 'carPapers':
            carPapers.add(file);
            break;
        }

        // Auto-upload after picking
        await _uploadSingleImage(type, file);
      }
    } catch (e) {
      LoggerUtils.debug('Error picking image: $e');
      Toast.showError('Failed to pick image');
    }
  }

  /// Remove car paper
  void removeCarPaper(int index) {
    if (index < carPapers.length) {
      carPapers.removeAt(index);
      if (index < carPapersUrls.length) {
        carPapersUrls.removeAt(index);
      }
    }
  }

  /// Upload single image to server
  Future<void> _uploadSingleImage(String type, File file) async {
    try {
      uploadingStates[type] = true;
      isUploading.value = true;

      var request = http.MultipartRequest('POST', Uri.parse(AppUrl.imageBaseUrl));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      LoggerUtils.debug('Uploading $type to ${AppUrl.imageBaseUrl}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      LoggerUtils.debug('Upload response status: ${response.statusCode}');
      LoggerUtils.debug('Upload response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Try different possible response formats
        final String imageUrl = data['filename'] ??
            data['url'] ??
            data['data']?['filename'] ??
            data['data']?['url'] ??
            '';

        if (imageUrl.isNotEmpty) {
          // Store URL based on type
          switch (type) {
            case 'cnicFront':
              cnicFrontUrl.value = imageUrl;
              break;
            case 'cnicBack':
              cnicBackUrl.value = imageUrl;
              break;
            case 'licenseFront':
              licenseFrontUrl.value = imageUrl;
              break;
            case 'licenseBack':
              licenseBackUrl.value = imageUrl;
              break;
            case 'carPapers':
              carPapersUrls.add(imageUrl);
              break;
          }

          // Toast.showSuccess('Image uploaded successfully');
          LoggerUtils.debug('Uploaded $type: $imageUrl');
        } else {
          Toast.showError('Failed to get image URL');
          LoggerUtils.debug('No URL in response: ${response.body}');
        }
      } else {
        Toast.showError('Upload failed: ${response.statusCode}');
        LoggerUtils.debug('Upload failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      LoggerUtils.debug('Error uploading image: $e');
      Toast.showError('Upload failed: $e');
    } finally {
      uploadingStates[type] = false;
      isUploading.value = uploadingStates.values.any((loading) => loading);
    }
  }

  /// Validate all documents
  bool validateDocuments() {
    if (cnicFrontUrl.value.isEmpty) {
      Toast.showError('Please upload CNIC front image');
      return false;
    }
    if (cnicBackUrl.value.isEmpty) {
      Toast.showError('Please upload CNIC back image');
      return false;
    }
    if (licenseFrontUrl.value.isEmpty) {
      Toast.showError('Please upload license front image');
      return false;
    }
    if (licenseBackUrl.value.isEmpty) {
      Toast.showError('Please upload license back image');
      return false;
    }
    // if (carPapersUrls.isEmpty) {
    //   Toast.showError('Please upload at least one car paper');
    //   return false;
    // }
    return true;
  }

  /// Get all document URLs for API submission
  Map<String, dynamic> getDocumentData() {
    return {
      'cnicFront': cnicFrontUrl.value,
      'cnicBack': cnicBackUrl.value,
      'licenseFront': licenseFrontUrl.value,
      'licenseBack': licenseBackUrl.value,
      'carPapers': carPapersUrls.toList(),
    };
  }

  @override
  void onClose() {
    // Clear all data
    cnicFront.value = null;
    cnicBack.value = null;
    licenseFront.value = null;
    licenseBack.value = null;
    carPapers.clear();
    super.onClose();
  }
}