import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(
    const MaterialApp(
      title: 'Globe Factual',
      home: MyContent(),
    ),
  );
}

Future<Country> fetchCountry() async {
  final response = await http
      .get(Uri.parse('https://restcountries.com/v3.1/name/deutschland'));

  if (response.statusCode == 200) {
    return Country.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('This failed');
  }
}

class Country {
  final String name;

  const Country({
    required this.name,
  });

  factory Country.fromJson(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      throw Exception('No data in list');
    }
    final firstItem = jsonList.first;
    if (firstItem is Map<String, dynamic>) {
      return Country(name: firstItem['name'].common as String);
    } else {
      throw Exception('Something is wrong ');
    }
  }
}

class MyContent extends StatefulWidget {
  const MyContent({super.key});

  @override
  State<MyContent> createState() => _MyContentState();
}

class _MyContentState extends State<MyContent> {
  late Future<Country> futureCountry;

  @override
  void initState() {
    super.initState();
    futureCountry = fetchCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Country>(
        future: futureCountry,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          } else if (snapshot.hasError) {
            return const Text('No data found ');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
