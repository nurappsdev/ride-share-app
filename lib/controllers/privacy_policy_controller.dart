import 'package:get/get.dart';
import 'package:split_ride/helpers/app_url.dart';
import 'package:split_ride/helpers/logger_util.dart';
import 'package:split_ride/helpers/secured_storage.dart';
import 'package:split_ride/services/network/network_caller.dart';
import 'package:split_ride/services/network/network_response.dart';
import 'package:split_ride/utils/app_constant.dart';

enum ContentType { privacyPolicy, termsAndConditions, aboutUs }

class PrivacyPolicyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString contentHtml = ''.obs;
  final RxString title = ''.obs;
  final RxString errorMessage = ''.obs;
  
  ContentType? currentContentType;

  @override
  void onInit() {
    super.onInit();
    // Get content type from arguments
    final contentTypeArg = Get.arguments?['contentType'] as ContentType?;
    final titleArg = Get.arguments?['title'] as String?;
    
    if (contentTypeArg != null) {
      currentContentType = contentTypeArg;
      title.value = titleArg ?? _getDefaultTitle();
      fetchContent();
    } else {
      // Default to privacy policy
      currentContentType = ContentType.privacyPolicy;
      title.value = titleArg ?? 'Privacy Policy';
      fetchContent();
    }
  }

  /// Get default title based on content type
  String _getDefaultTitle() {
    switch (currentContentType) {
      case ContentType.privacyPolicy:
        return 'Privacy Policy';
      case ContentType.termsAndConditions:
        return 'Terms & Conditions';
      case ContentType.aboutUs:
        return 'About Us';
      default:
        return 'Privacy Policy';
    }
  }

  /// Get API URL based on content type
  String _getApiUrl() {
    switch (currentContentType) {
      case ContentType.privacyPolicy:
        return AppUrl.privacyPolicy;
      case ContentType.termsAndConditions:
        return AppUrl.termsAndConditions;
      case ContentType.aboutUs:
        return AppUrl.aboutUs;
      default:
        return AppUrl.privacyPolicy;
    }
  }

  /// Fetch content from backend
  Future<void> fetchContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final String token = await SecureStorageService().read(
        AppConstants.accessToken,
      ) ?? '';
      
      final String url = _getApiUrl();
      
      LoggerUtils.debug('Fetching $title from: $url');
      
      final NetworkResponse response = await NetworkCaller().getRequest(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      LoggerUtils.debug('Response status: ${response.isSuccess}');
      LoggerUtils.debug('Response code: ${response.statusCode}');
      
      if (response.isSuccess) {
        // Try different possible response structures
        final data = response.jsonResponse?['data'];
        
        if (data != null) {
          // Try common field names for HTML content
          String htmlContent = data['content'] ?? 
                               data['html'] ?? 
                               data['value'] ?? 
                               data['text'] ?? 
                               data['description'] ?? 
                               '';
          
          // If data is a string directly
          if (data is String) {
            htmlContent = data;
          }
          
          if (htmlContent.isNotEmpty) {
            contentHtml.value = htmlContent;
            LoggerUtils.debug('Content loaded successfully (${htmlContent.length} chars)');
          } else {
            // No content found, use fallback
            _useFallbackContent();
          }
        } else {
          // No data field, use fallback
          _useFallbackContent();
        }
      } else {
        LoggerUtils.error('Failed to fetch content: ${response.errorMessage}');
        errorMessage.value = response.errorMessage ?? 'Failed to load content';
        _useFallbackContent();
      }
    } catch (e) {
      LoggerUtils.debug('Error fetching content: $e');
      errorMessage.value = 'Error loading content: ${e.toString()}';
      _useFallbackContent();
    } finally {
      isLoading.value = false;
    }
  }

  /// Use fallback content if API fails
  void _useFallbackContent() {
    switch (currentContentType) {
      case ContentType.privacyPolicy:
        contentHtml.value = _getPrivacyPolicyFallback();
        break;
      case ContentType.termsAndConditions:
        contentHtml.value = _getTermsFallback();
        break;
      case ContentType.aboutUs:
        contentHtml.value = _getAboutUsFallback();
        break;
      default:
        contentHtml.value = _getPrivacyPolicyFallback();
    }
  }

  /// Fallback Privacy Policy content
  String _getPrivacyPolicyFallback() {
    return '''
      <h2>Privacy Policy for Split Ride</h2>
      <p><strong>Effective Date:</strong> 29/10/2025</p>
      <p>This Privacy Policy describes how Split Ride collects, uses, discloses, and protects your personal data when you use our mobile application and services.</p>
      
      <h3>1. Information We Collect</h3>
      <p>We collect information you provide directly including name, email, phone number, pickup and drop-off locations, and payment details.</p>
      
      <h3>2. How We Use Your Information</h3>
      <p>We use your information to provide ride-sharing services, process payments, communicate with you, and improve our services.</p>
      
      <h3>3. Data Security</h3>
      <p>We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, loss, or misuse.</p>
      
      <h3>4. Your Rights</h3>
      <p>You have the right to access, rectify, erase, or port your personal data. Contact us at info@splitride.com.cy to exercise these rights.</p>
      
      <h3>5. Contact Us</h3>
      <p>For any privacy-related questions, please contact us at info@splitride.com.cy</p>
    ''';
  }

  /// Fallback Terms & Conditions content
  String _getTermsFallback() {
    return '''
      <h2>Terms & Conditions</h2>
      <p><strong>Effective Date:</strong> 29/10/2025</p>
      
      <h3>1. Acceptance of Terms</h3>
      <p>By accessing and using Split Ride, you accept and agree to be bound by these Terms and Conditions.</p>
      
      <h3>2. Use of Service</h3>
      <p>You agree to use Split Ride only for lawful purposes and in accordance with these terms.</p>
      
      <h3>3. User Responsibilities</h3>
      <p>Users are responsible for maintaining the confidentiality of their account and for all activities that occur under their account.</p>
      
      <h3>4. Payment Terms</h3>
      <p>All payments for rides must be made through the approved payment methods in the app.</p>
      
      <h3>5. Limitation of Liability</h3>
      <p>Split Ride shall not be liable for any indirect, incidental, or consequential damages arising from the use of our services.</p>
      
      <h3>6. Contact</h3>
      <p>For questions about these terms, contact us at info@splitride.com.cy</p>
    ''';
  }

  /// Fallback About Us content
  String _getAboutUsFallback() {
    return '''
      <h2>About Split Ride</h2>
      <p>Split Ride is a Cyprus-based taxi booking and ride-sharing platform, designed to connect passengers with registered taxi drivers for pre-scheduled or shared transportation across Cyprus.</p>
      
      <h3>Our Mission</h3>
      <p>To provide affordable, convenient, and eco-friendly transportation options by enabling ride-sharing among passengers traveling in the same direction.</p>
      
      <h3>Our Services</h3>
      <ul>
        <li>Split Ride - Share your ride and save up to 50%</li>
        <li>Private Ride - Exclusive transportation for you</li>
        <li>Scheduled Rides - Book in advance</li>
      </ul>
      
      <h3>Contact Information</h3>
      <p><strong>Email:</strong> info@splitride.com.cy</p>
      <p><strong>Website:</strong> https://splitride.com.cy</p>
      <p><strong>Location:</strong> Cyprus (Limassol, Nicosia, Larnaca, Paphos)</p>
      
      <h3>Developer</h3>
      <p>The website and application have been designed, developed, and maintained by LOOP Digital Marketing LTD.</p>
      <p><strong>Email:</strong> contact@loopdigitalmarketing.com</p>
    ''';
  }

  /// Refresh content (pull-to-refresh)
  Future<void> refreshContent() async {
    await fetchContent();
  }
}
