import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class PrivacyPolicyAllScreen extends StatefulWidget {
  const PrivacyPolicyAllScreen({super.key});

  @override
  State<PrivacyPolicyAllScreen> createState() => _PrivacyPolicyAllScreenState();
}

class _PrivacyPolicyAllScreenState extends State<PrivacyPolicyAllScreen> {
  // PrivacyPolicyController policyController = Get.put(PrivacyPolicyController());
  //
  // @override
  // void initState() {
  //   policyController.getPrivacyPolicyAll(
  //     url: Get.arguments["title"] == "Term & Condition"
  //         ? "/setting/terms-conditions"
  //         : Get.arguments["title"] == "Privacy Policy"
  //         ? "/setting/privacy-policy"
  //         : "/setting/about-us",
  //   );
  //   super.initState();
  // }

  @override
  void dispose() {
    // policyController.valueText.value = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("{Get.arguments[""]}")),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child:
          //Obx(
            // () => policyController.valueText.isEmpty
            //     ? CustomLoader()
            //     :
            Column(
                    children: [
                      SizedBox(height: 20.h),

                      // CustomText(
                      //   color: Colors.black,
                      //   maxline: 1000,
                      //   textAlign: TextAlign.start,
                      //   text: "${policyController.valueText.value}",)
                      //
                      HtmlWidget(
                        """Privacy Policy for Split Ride
– Cyprus Taxi Booking App
Effective Date: 29/10/2025
Last Updated: 29/10/2025

This Privacy Policy describes how Split Ride (“Split Ride”, “we”, “us”, “our”) collects, uses, discloses, and protects the personal data of users (“you”, “your”) when you use our mobile application, website (https://splitride.com.cy
), or any of our related services (collectively referred to as “the Platform”).

Split Ride is a Cyprus-based taxi booking and ride-sharing platform, designed to connect passengers with registered taxi drivers and ride partners for pre-scheduled or shared transportation across Cyprus, including Limassol, Nicosia, Larnaca, and Paphos.

The website and application have been designed, developed, and maintained by LOOP Digital Marketing LTD, a Cyprus-based web development and digital marketing agency (Email: contact@loopdigitalmarketing.com
). LOOP Digital Marketing LTD acts solely as a technical service provider and is not responsible for the operation, management, or any damages arising from the use of the Split Ride platform.

1. Introduction and Scope
This Privacy Policy applies to:
The Split Ride mobile app (iOS and Android)
The Split Ride website at https://splitride.com.cy
Any communication or interaction through our contact forms, chat systems, or emails
Any services, features, or content offered under the Split Ride brand
By using Split Ride, you agree to the collection, processing, and storage of your personal data in accordance with this Privacy Policy and the General Data Protection Regulation (EU 2016/679 – GDPR).

If you do not agree with any of the terms described herein, please discontinue use of the Platform immediately.

2. Data Controller and Contact Information
Split Ride Ltd
Website: https://splitride.com.cy
Email: info@splitride.com.cy
Registered in the Republic of Cyprus

For any privacy-related inquiries, you may also contact our data protection partner:
LOOP Digital Marketing LTD
Email: contact@loopdigitalmarketing.com

3. Information We Collect
We collect several types of information to provide our taxi booking, ride-sharing, and transfer services efficiently and securely.
Information You Provide Directly
When you create an account or book a ride, we collect:
Full name
Email address
Mobile phone number
Pickup and drop-off locations
Payment details (if applicable)
Ride preferences (shared or private)
Feedback, support messages, or reviews
When you contact us, we may also collect any information you provide voluntarily (attachments, screenshots, location references, or ride details).

Automatically Collected Information
When you use the app or website, we automatically collect:
Device information (model, OS version, IP address, unique identifiers)
Location data (GPS coordinates, approximate region)
Browser data (type, version, language, referrer, time zone)
Usage statistics (pages visited, app screens, duration of sessions)
Crash logs or performance analytics

Information from Third Parties
We may receive data from:
Payment gateways
Analytics providers (e.g., Google Analytics)
Advertising networks
Social login services (e.g., Google, Apple, Facebook)
Driver or fleet partners
All such third parties are required to comply with GDPR and handle data securely.

4. Use of Collected Information
We use your personal data to:
Provide and manage taxi booking and ride-sharing services
Process ride payments and send ride confirmations or receipts
Match passengers with suitable drivers or shared ride partners
Communicate with users about bookings, changes, or updates
Ensure service reliability, safety, and fraud prevention
Respond to support tickets and feedback
Improve app functionality, user experience, and technical performance
Conduct marketing and promotional campaigns (only with your consent)
Comply with applicable laws and regulations in Cyprus and the EU

5. Legal Basis for Processing
We process personal data under the following lawful bases:
Performance of a Contract
Legitimate Interest
Consent
Legal Obligation

6. Cookies and Tracking Technologies
Our website and app use cookies and similar technologies for:
Session management
Analytics and performance tracking (Google Analytics, Firebase, etc.)
Advertising optimization (Google Ads, Meta Pixel, etc.)
You can control cookie settings via your browser or device preferences. Disabling cookies may limit certain features or functionalities.

Google Analytics:
Split Ride uses Google Analytics to collect anonymized usage data for improving our platform. Google may process this data according to their Privacy Policy: https://policies.google.com/privacy
You can opt out using the Google Analytics Opt-out Add-on: https://tools.google.com/dlpage/gaoptout

7. Payment Information
Payments (if applicable) are processed by third-party payment processors in compliance with PCI-DSS standards. Split Ride does not store full credit card details on its servers.

Transaction data, such as payment status or refund confirmations, may be stored for accounting and legal purposes.

8. Location Data
For optimal ride-matching and accurate pickup/drop-off functionality, Split Ride may collect and process your real-time GPS location. You may disable location access from your device settings; however, doing so may restrict certain features (e.g., ride tracking or driver arrival updates).

9. Data Retention
We retain personal data only for as long as necessary to:
Provide our services
Comply with legal obligations
Resolve disputes
Enforce agreements
Inactive user accounts may be anonymized or deleted after 24 months of inactivity unless legal or regulatory obligations require longer retention.

10. Data Sharing and Disclosure
We may share data with:
Drivers or fleet partners
Payment processors
IT and hosting providers
Analytics and marketing partners
Legal and regulatory authorities
LOOP Digital Marketing LTD (for maintenance only)
LOOP Digital Marketing LTD has no access to payment or sensitive user data and bears no responsibility for the actions of Split Ride Ltd, its users, or its drivers.

11. Data Security
We implement comprehensive technical and organizational measures to protect personal data against:
Unauthorized access
Loss or destruction
Alteration or misuse

Security features include:
SSL encryption
Secure database storage
Access restrictions
Regular security audits
Despite our efforts, no system is entirely secure. Split Ride and LOOP Digital Marketing LTD cannot guarantee absolute data security, and users accept this inherent risk by using the Platform.

12. User Rights under GDPR
Users have the right to:
Access their personal data

Rectify inaccurate information

Erase data (“Right to be forgotten”)

Restrict processing

Object to processing for marketing or legitimate interests

Request data portability

Withdraw consent at any time
To exercise these rights, contact info@splitride.com.cy . Requests are processed within 30 days.

13. International Data Transfers
All data is processed and stored within the European Economic Area (EEA). If a third-party service provider processes data outside the EEA, we ensure appropriate safeguards (such as EU Standard Contractual Clauses).

14. Third-Party Services and Links
Our Platform may contain links to third-party websites or apps not operated by us. We are not responsible for the privacy practices or content of these third parties.

Examples include:
Google Maps
App Store / Google Play
Payment gateways
Facebook, Instagram, or other social networks
Users are encouraged to review each third party’s privacy policy.

15. Children’s Privacy
Split Ride services are not intended for persons under 18 years of age. We do not knowingly collect personal data from minors. If we discover such data has been collected, we will delete it promptly.

16. Communications and Marketing
By providing your contact details, you agree to receive:
Transactional messages (ride confirmations, receipts)
Service updates and notifications
Marketing or promotional messages (only with consent)
You may unsubscribe from marketing emails at any time by following the unsubscribe link or contacting us directly.

17. Account Termination and Data Deletion
Users can delete their account or request data deletion by emailing info@splitride.com.cy
. Upon verification, all personal data will be permanently deleted, except where retention is required by law (e.g., financial transactions, legal disputes).

18. Liability Disclaimer for LOOP Digital Marketing LTD
LOOP Digital Marketing LTD, the developer and technical service provider of the Split Ride platform, assumes no responsibility or liability for:
Operational issues, ride cancellations, or driver actions
Data loss caused by Split Ride’s internal systems or user error
Misuse or illegal use of the app by third parties
Technical downtime, cyberattacks, or third-party service interruptions
LOOP Digital Marketing LTD’s role is purely developmental and maintenance-based. All operational, transactional, and customer-related liabilities rest solely with Split Ride Ltd.

19. Changes to This Privacy Policy
We may update this Privacy Policy periodically to reflect legal, operational, or technological changes. Updates will be published on https://splitride.com.cy/privacy-policy
 and the “Last Updated” date will be revised accordingly.
Users are encouraged to review this page regularly.

20. Governing Law and Jurisdiction
This Privacy Policy shall be governed by and construed in accordance with the laws of the Republic of Cyprus and applicable EU Data Protection Regulations.
Any disputes arising in connection with this Policy shall be subject to the exclusive jurisdiction of the courts of Limassol, Cyprus.

21. Contact Information
Split Ride Ltd
Email: info@splitride.com.cy
Website: https://splitride.com.cy
Developer Contact:
LOOP Digital Marketing LTD
Email: contact@loopdigitalmarketing.com

22. Acceptance of Policy
By downloading, installing, or using the Split Ride mobile app or accessing our website, you acknowledge that you have read, understood, and agreed to the terms of this Privacy Policy.
If you do not agree with this Policy, please discontinue using Split Ride and uninstall the app from your device.

Appendix A – Data Collected""",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14.h,
                        ),
                      ),
                    ],
                  ),
          ),
        // ),
      ),
    );
  }
}
