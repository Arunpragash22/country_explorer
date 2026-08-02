import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/country.dart';
import '../services/country_service.dart';

final countryProvider = FutureProvider<List<Country>>((ref) async {
  return CountryService().getCountries();
});