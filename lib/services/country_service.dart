import 'package:dio/dio.dart';
import '../models/country.dart';

class CountryService {
  final Dio dio = Dio();

  Future<List<Country>> getCountries() async {
    final response = await dio.get(
  "https://api.sampleapis.com/countries/countries",);

   List data = response.data;

   print(data.first);
  return data.map((json) {
    return Country.fromJson(json);
  }).toList();

  }
}