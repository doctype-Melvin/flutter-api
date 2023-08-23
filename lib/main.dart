import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(
    const MaterialApp(
      title: 'Globe Factual',
    ),
  );
}

Future<void> fetchCountry() async {
  final response =
      await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  } else {
    throw Exception('This failed');
  }
}
