import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> shareImage(Uint8List pngBytes, String filename) async {
    final xFile = XFile.fromData(
      pngBytes,
      mimeType: 'image/png',
      name: filename,
    );
    await SharePlus.instance.share(ShareParams(files: [xFile]));
  }
}
