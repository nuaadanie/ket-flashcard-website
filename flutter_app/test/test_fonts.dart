import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads Google Fonts (Quicksand, Fredoka, Inter) into the test font system
/// so widget tests don't need network access for font fetching.
///
/// Call this in setUp() before pumpWidget().
Future<void> loadTestFonts() async {
  final fonts = {
    'Quicksand': 'test/fonts/Quicksand-Regular.ttf',
    'Fredoka': 'test/fonts/Fredoka-Bold.ttf',
    'Inter': 'test/fonts/Inter-Regular.ttf',
  };

  for (final entry in fonts.entries) {
    final file = File(entry.value);
    final bytes = await file.readAsBytes();
    final fontLoader = FontLoader(entry.key)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await fontLoader.load();
  }
}
