import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'web_download_stub.dart'
    if (dart.library.html) 'web_download_web.dart';

class PostImageExportService {
  /// Renders the [RepaintBoundary] attached to [key] as a PNG.
  ///
  /// [pixelRatio] controls resolution — 2.0 gives @2x quality suitable for
  /// most social-media uses. Returns null if the widget is not yet painted.
  Future<Uint8List?> renderToPng(
    GlobalKey key, {
    double pixelRatio = 2.0,
  }) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  /// Triggers a browser download on web platforms; no-op elsewhere.
  void downloadOnWeb(String filename, Uint8List bytes) {
    downloadFileWeb(filename, bytes);
  }

  /// Builds a canonical export filename for a post.
  String filenameFor(String quizId, String questionId) =>
      'catlab_quiz_${quizId}_$questionId.png';
}
