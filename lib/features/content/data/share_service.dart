import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  /// Shares a PNG image, optionally with [text].
  ///
  /// Returns `true` if text was included in the share sheet.
  /// Returns `false` if the platform rejected the combined share — callers
  /// should copy [text] to the clipboard and show a fallback message.
  Future<bool> shareImage(
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
      if (result.status != ShareResultStatus.unavailable) return true;
      // Platform rejected files+text — fall through to image-only.
    }

    await SharePlus.instance.share(ShareParams(files: [xFile]));
    return false;
  }
}
