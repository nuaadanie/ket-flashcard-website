import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/src/google_fonts_base.dart';
import 'package:http/http.dart' as http;

/// Mocks google_fonts internals so widget tests don't need network access.
///
/// - Replaces [httpClient] with a mock that returns real TTF bytes matching
///   the expected SHA256 hashes for each font variant.
/// - Calls [clearCache] to reset loaded font state.
///
/// Call this in setUp() before pumpWidget().
void setupGoogleFontsMocks() {
  // Build a map from hash -> real font bytes so the mock can return
  // the correct font for any hash-based URL.
  final fontMap = <String, Uint8List>{};
  for (final entry in _fontFiles.entries) {
    final bytes = File('test/fonts/${entry.value}').readAsBytesSync();
    fontMap[entry.key] = bytes;
  }

  httpClient = _FakeHttpClient(fontMap);
  clearCache();
}

/// Maps SHA256 hash (from GoogleFontsFile.expectedFileHash) to the
/// corresponding local font filename.
const _fontFiles = <String, String>{
  // Quicksand
  '1af2320c17e48cec8f6f73590d9ff01e2c391182dca5a1c4aae4f13ff74b3d27':
      'Quicksand-Regular.ttf', // w400
  '1706916eebf8882bedc1c8f4a7300c744431eac4b54c820ea5502196d387dd8b':
      'Quicksand-Light.ttf', // w300
  '656b9306f9d219ab4ab3a75cead3dbfbd95c2e03810da37caf64f657fe7797c2':
      'Quicksand-Medium.ttf', // w500
  'eafa4e892358ecd36b0985550d530d2fe41e4147d0cc9fb212008d5d9c44257e':
      'Quicksand-SemiBold.ttf', // w600
  '75e85595ac7acf57cdb1c64202577c48150e7aee3fcf600c558d082b040cb8c1':
      'Quicksand-Bold.ttf', // w700
  // Fredoka
  '3b03d94bb7fbe0c6f76d53f78be7912b22eac5b860ad1b566892d8a24a93eb9c':
      'Fredoka-Light.ttf', // w300
  '2a5db7832feb3b8261603fc01e4411601c9b08d4107d3ddacc6b1a1b24a98078':
      'Fredoka-Regular.ttf', // w400
  'f33d2fcedde5d0920682170e6088df9501bab260f84d94213b0e0388d5586fa6':
      'Fredoka-Medium.ttf', // w500
  '241f09c2822f1cde8677dc18da3fc2b9f35e87926f3fe4fd687538098f5d55fa':
      'Fredoka-SemiBold.ttf', // w600
  'fb87f9cd22fc2af57c25c381f17d470f7d7ab40e19f51975b6c5b069051718d3':
      'Fredoka-Bold.ttf', // w700
  // Inter
  '15b294b67f2f8bbc04d990023ef4aec66502b87dc9040d84abe5f896ccb693de':
      'Inter-Regular.ttf', // w400
  '36a36ff7ac46dc2aeceac3a80a87a67e7b844b8fc936699259aac8fba9bcf734':
      'Inter-Regular.ttf', // w500
  '76121a34a606cc8a0e1ef5a47d2b9ba9678c41f5c852d63eb28f62069373bfad':
      'Inter-Bold.ttf', // w700
};

class _FakeHttpClient implements http.Client {
  final Map<String, Uint8List> _fontMap;

  _FakeHttpClient(this._fontMap);

  Uint8List _bytesForUrl(Uri url) {
    // URL pattern: https://fonts.gstatic.com/s/a/{hash}.ttf
    final hash = url.pathSegments.last.replaceAll('.ttf', '');
    return _fontMap[hash] ?? Uint8List(0);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async =>
      http.Response.bytes(_bytesForUrl(url), 200);

  @override
  void close() {}

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async =>
      http.Response('', 200);

  @override
  Future<http.Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      http.Response('', 200);

  @override
  Future<http.Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      http.Response('', 200);

  @override
  Future<http.Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      http.Response('', 200);

  @override
  Future<http.Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) async =>
      http.Response('', 200);

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async => '';

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async =>
      Uint8List(0);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(Stream.value(_bytesForUrl(request.url)), 200);
}
