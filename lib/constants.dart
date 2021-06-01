import 'package:flutter/material.dart';

class ColorConstants {
  static const Color primaryDark = Color.fromARGB(255, 25, 31, 34);
}

class AssetConstants {
  static const String LOGO_SVG = 'assets/images/rendezvous-logo.svg';
  static const String FACEBOOK_ICON = 'assets/images/facebook.svg';
  static const String GOOGLE_ICON = 'assets/images/google.svg';
  static const String APPLE_ICON = 'assets/images/apple.svg';
  static const String HAND_POINTER_ICON = 'assets/images/hand-pointer.svg';
}

class StringConstants {
  static const String APPLICATION_TITLE = 'Rendezvous';
  static const String OR_SEPARATOR = 'OR';
  static const String CREATE_ACCOUNT_ROUTE_NAME = 'CREATE_ACCOUNT_ROUTE_NAME';
  static const String COUNTRIES_LIST_ASSET = "assets/countries.json";
}

enum AuthenticationAction { CREATE_ACCOUNT, LOGIN }
