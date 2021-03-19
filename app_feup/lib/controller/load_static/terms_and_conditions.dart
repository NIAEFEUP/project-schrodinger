import 'package:flutter/services.dart' show rootBundle;

/// Returns the content of the Terms and Conditions file.
/// 
/// If this operation is unsuccessful, an error message is returned.
Future<String> readTermsAndConditions() async {
  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    return 'Could not load terms and conditions. Please try again later';
  }
}
