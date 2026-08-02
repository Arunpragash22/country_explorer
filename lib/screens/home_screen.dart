import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import 'details_screen.dart';
import '../providers/country_provider.dart';
import 'bucket_screen.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countryProvider);
    final search = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Explorer"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BucketScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: countriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text("Error: $error"),
        ),
        data: (countries) {
          final filteredCountries = countries.where((country) {
            return country.name.toLowerCase().contains(search.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search Country...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(country: country),
                          ),
                        );
                      },
                      leading: Image.network(
                        country.flag,
                        width: 50,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.public);
                        },
                      ),
                      title: Text(country.name),
                      subtitle: Text(country.capital),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}