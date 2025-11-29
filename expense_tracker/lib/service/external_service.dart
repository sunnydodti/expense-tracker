import 'package:url_launcher/url_launcher.dart';

import '../ui/notifications/snackbar_service.dart';

class ExternalService {
  static Future<void> launchURL(String? link) async {
    if (link == null) return;
    final Uri uri = Uri.parse(link);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      SnackBarService.showErrorSnackBar('Could not launch $link');
    }
  }
}
