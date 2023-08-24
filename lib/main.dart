import 'package:flutter/material.dart';
import 'package:locale_emoji_flutter/locale_emoji_flutter.dart' as le;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(
    const MaterialApp(
      title: 'Globe Factual',
      home: MyContent(),
    ),
  );
}

Future<Country> fetchCountry() async {
  final response =
      await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

  if (response.statusCode == 200) {
    // final fullList = jsonDecode(response.body);
    // Random random = Random();
    // int randomNumber = random.nextInt(250);
    // final randomCountry = fullList[randomNumber];
    // return Country.fromJson(randomCountry);
    return Country.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('This failed');
  }
}

class Country {
  final String name;
  final String localeCode;
  final String flagPng;

  const Country({
    required this.name,
    required this.localeCode,
    required this.flagPng,
  });

  factory Country.fromJson(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      throw Exception('No data in list');
    }
    Random random = Random();
    int randomNumber = random.nextInt(250);
    final randomItem = jsonList[randomNumber];
    if (randomItem is Map<String, dynamic>) {
      return Country(
        name: randomItem['name']['official'] as String,
        localeCode: randomItem['cca3'] as String,
        flagPng: randomItem['flags']['png'] as String,
      );
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
            return CountryDetails(
              name: snapshot.data!.name,
              localeCode: snapshot.data!.localeCode,
              flagPng: snapshot.data!.flagPng,
            );
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
  const CountryDetails(
      {required this.name,
      required this.localeCode,
      required this.flagPng,
      super.key});

  final String name;
  final String localeCode;
  final String flagPng;

  @override
  Widget build(BuildContext context) {
    return Center(
      // height: 150,
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          Text(
            localeCode,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 50),
          ),
          Image(
            image: NetworkImage(flagPng),
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
