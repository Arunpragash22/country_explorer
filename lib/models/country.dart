class Country {
  final String name;
  final String capital;
  final String flag;
  final String currency;
  final String phone;
  final int population;


  Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.currency,
    required this.phone,
    required this.population,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? 'Unknown',
      capital: json['capital'] ?? 'No Capital',
      flag: json['media']?['flag'] ?? '',
      currency: json['currency'] ?? 'Unknown',
      phone: json['phone'] ?? 'Unknown',
      population: int.tryParse(json['population'].toString()) ?? 0,
    );
  }
}