import 'package:flutter/material.dart';
import 'package:locale_emoji_flutter/locale_emoji_flutter.dart' as le;
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
  final String native;

  const Country({
    required this.native,
  });

  factory Country.fromJson(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      throw Exception('No data in list');
    }
    final firstItem = jsonList[0];
    if (firstItem is Map<String, dynamic>) {
      return Country(
          native: firstItem['name']['nativeName']['deu']['official'] as String);
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
            return CountryDetails(native: snapshot.data!.native);
          } else if (snapshot.hasError) {
            return const Text('No data found ');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class CountryDetails extends StatelessWidget {
  const CountryDetails({required this.native, super.key});

  final String native;

  @override
  Widget build(BuildContext context) {
    return Center(
      // height: 150,
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            native,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const Text(
            '🇿🇦',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 50),
          )
        ],
      ),
    );
  }
}
