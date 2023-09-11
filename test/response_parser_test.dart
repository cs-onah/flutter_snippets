import 'package:flutter_snippets/src/response_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group("parseCoordinate", () {
    late String raw = "[[3.2821357, 6.6825654]";

    test("Unclean coordinate is cleaned up", () {
      LatLng? testResult = ResParse.parseCoordinate(raw);
      expect(testResult, const LatLng(3.2821357, 6.6825654));
    });
  });
}
