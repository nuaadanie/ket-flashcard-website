import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/src/google_fonts_base.dart';
import 'package:http/http.dart' as http;

/// Mocks google_fonts internals so widget tests don't need network access.
///
/// - Replaces [httpClient] with a mock that returns valid TTF bytes.
/// - Replaces [assetManifest] with an empty manifest (no bundled fonts).
/// - Calls [clearCache] to reset loaded font state.
///
/// Call this in setUp() before pumpWidget().
void setupGoogleFontsMocks() {
  final fontBytes = File('test/fonts/Quicksand-Regular.ttf').readAsBytesSync();

  httpClient = _FakeHttpClient(fontBytes);
  assetManifest = _FakeAssetManifest();
  clearCache();
}

class _FakeHttpClient implements http.Client {
  final Uint8List _bytes;

  _FakeHttpClient(this._bytes);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async =>
      http.Response.bytes(_bytes, 200);

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
      http.StreamedResponse(Stream.value(_bytes), 200);
}

class _FakeAssetManifest implements AssetManifest {
  @override
  List<String> listAssets() => <String>[];

  @override
  List<AssetMetadata>? getAssetVariants(String key) => null;

  @override
  Future<void> loadFromAssetBundle(AssetBundle bundle) async {}
}
