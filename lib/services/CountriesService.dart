import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rendezvous/models/Country.dart';

class CountriesService {
  static Future<List<Country>> fetchCountryData(
      BuildContext context, String jsonFile) async {
    var list = await DefaultAssetBundle.of(context).loadString(jsonFile);
    List<Country> elements = [];
    var jsonList = await jsonDecode(list);
    jsonList.forEach((s) {
      Map elem = Map.from(s);
      elements.add(Country(
        name: elem['en_short_name'],
        code: elem['alpha_2_code'],
        dialCode: elem['dial_code'],
      ));
    });
    return elements;
  }
}
