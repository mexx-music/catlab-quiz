import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

/// Result of an image share attempt.
enum ShareImageOutcome {
  /// Image (and text, if provided) reached the share sheet.
  sharedWithText,

  /// Image reached the share sheet; combined text+image was rejected so only
  /// the image was shared (caller should surface text via clipboard).
  sharedImageOnly,

  /// The share API is completely unavailable on this platform/browser.
  /// Caller should offer a manual fallback (clipboard + download).
  failed,
}

class ShareService {
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  /// Shares a PNG image, optionally with [text].
  ///
  /// Strategy:
  /// 1. Try image + text together.
  /// 2. If rejected, try image only.
  /// 3. If that also fails → return [ShareImageOutcome.failed].
  Future<ShareImageOutcome> shareImage(
    Uint8List pngBytes,
    String filename, {
    String? text,
  }) async {
    final xFile = XFile.fromData(
      pngBytes,
      mimeType: 'image/png',
      name: filename,
    );

    if (text != null) {
      final result = await SharePlus.instance.share(
        ShareParams(files: [xFile], text: text),
      );
      if (result.status != ShareResultStatus.unavailable) {
        return ShareImageOutcome.sharedWithText;
      }
      // files+text rejected — try image alone.
    }

    final result =
        await SharePlus.instance.share(ShareParams(files: [xFile]));
    if (result.status != ShareResultStatus.unavailable) {
      return ShareImageOutcome.sharedImageOnly;
    }

    return ShareImageOutcome.failed;
  }
}
