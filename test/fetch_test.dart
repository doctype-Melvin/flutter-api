import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchCountry() async {
  final response = await http
      .get(Uri.parse('https://restcountries.com/v3.1/name/deutschland'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  } else {
    throw Exception('This failed');
  }
}

void main() async {
  try {
    await fetchCountry();
  } catch (error) {
    print('Error: $error');
  }
}
