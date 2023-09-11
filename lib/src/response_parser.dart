import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResParse {
  static parseString(dynamic value) => value.toString();

  static int? parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is int) return value;
    if (value is double) return value.round();
    return null;
  }

  static DateTime? parseDateTime(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '');
  }

  static double? parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value);
    }
    if (value is double) return value;
    if (value is int) return double.tryParse(value.toString());
    return null;
  }

  static num? parseNum(dynamic value) {
    if (value is String) {
      return num.tryParse(value);
    }
    if (value is num) return value;
    return null;
  }

  static bool? parseBool(dynamic value) {
    if (value is num) {
      if (value == 0) return false;
      if (value == 1) return true;
    }
    if (value is String) {
      if (value == "0") return false;
      if (value == "1") return true;
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
      if (value.toLowerCase() == 'on') return true;
      if (value.toLowerCase() == 'off') return false;
      if (value.toLowerCase() == 'yes') return true;
      if (value.toLowerCase() == 'no') return false;
    }
    if (value is bool) return value;
    return null;
  }

  static LatLng? parseCoordinate(dynamic value, {bool firstAsLat = true}) {
    if (value is List) {
      return latLngFromList(value, firstAsLat);
    }
    if (value is String) {
      try {
        /// added to clean up data
        value = value.replaceAll("[[", "[");
        value = value.replaceAll("]]", "]");
        final res = json.decode(value).cast<num>().toList();
        return latLngFromList(res, firstAsLat);
      } catch (_) {}
    }
    return null;
  }

  /// if [latAsFirst] uses first item in the list as latitude
  static LatLng? latLngFromList(List value, bool latAsFirst) {
    if (value.length >= 2) {
      return latAsFirst
          ? LatLng(value[0], value[1])
          : LatLng(value[1], value[0]);
    }
    return null;
  }
}
