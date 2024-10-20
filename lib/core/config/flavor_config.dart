import 'package:flutter/material.dart';

enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class FlavorValues {
  final String portalBaseUrl;
  final String mdSOABaseUrl;

  FlavorValues({
    required this.portalBaseUrl,
    required this.mdSOABaseUrl,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color colorPrimary;
  final Color colorPrimaryDark;
  final Color colorPrimaryLight;
  final Color colorAccent;
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color colorPrimary = Colors.blue,
    Color colorPrimaryDark = Colors.blue,
    Color colorPrimaryLight = Colors.blue,
    Color colorAccent = Colors.blueAccent,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(
      flavor,
      enumName(flavor.toString()),
      colorPrimary,
      colorPrimaryDark,
      colorPrimaryLight,
      colorAccent,
      values,
    );
    return _instance;
  }

  FlavorConfig._internal(
    this.flavor,
    this.name,
    this.colorPrimary,
    this.colorPrimaryDark,
    this.colorPrimaryLight,
    this.colorAccent,
    this.values,
  );

  static FlavorConfig get instance {
    return _instance;
  }

  static String enumName(String enumToString) {
    var paths = enumToString.split('.');
    return paths[paths.length - 1];
  }

  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;

  static bool isDevelopment() => _instance.flavor == Flavor.DEVELOPMENT;
}
