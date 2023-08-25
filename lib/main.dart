import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(
    const MaterialApp(
      title: 'Globe Factual',
      home: Scaffold(body: MyContent()),
    ),
  );
}

class Country {
  final String name;
  final String localeCode;
  final String flagPng;
  final String region;
  final String capital;
  final int population;

  const Country({
    required this.name,
    required this.localeCode,
    required this.flagPng,
    required this.region,
    required this.capital,
    required this.population,
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
        region: randomItem['region'] as String,
        capital: randomItem['capital'][0],
        population: randomItem['population'],
      );
    } else {
      throw Exception('Failed to generate Country from JSON list');
    }
  }
}

Future<Country> fetchCountry() async {
  final response =
      await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

  if (response.statusCode == 200) {
    return Country.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Bad response while fetching data');
  }
}

class CountryDetails extends StatelessWidget {
  const CountryDetails(
      {required this.name,
      required this.localeCode,
      required this.flagPng,
      required this.region,
      required this.capital,
      required this.population,
      super.key});

  final String name;
  final String localeCode;
  final String flagPng;
  final String region;
  final String capital;
  final int population;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.blueGrey[800],
              )),
          Image(
            image: NetworkImage(flagPng),
            fit: BoxFit.cover,
          ),
          Text(
            localeCode,
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Capital: $capital',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
                fontSize: 25),
          ),
          Text('Population: $population',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey[600],
              )),
        ],
      ),
    );
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

  void fetchNewCountry() {
    setState(() {
      futureCountry = fetchCountry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<Country>(
            future: futureCountry,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CountryDetails(
                  name: snapshot.data!.name,
                  localeCode: snapshot.data!.localeCode,
                  flagPng: snapshot.data!.flagPng,
                  region: snapshot.data!.region,
                  capital: snapshot.data!.capital,
                  population: snapshot.data!.population,
                );
              } else if (snapshot.hasError) {
                return const Text('No data found ');
              }
              return const CircularProgressIndicator();
            },
          ),
          ElevatedButton(
            onPressed: fetchNewCountry,
            child: const Text('Random Country'),
          )
        ],
      ),
    );
  }
}
