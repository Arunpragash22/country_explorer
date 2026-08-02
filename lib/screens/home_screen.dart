import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../providers/sort_provider.dart';
import '../providers/country_provider.dart';

import 'details_screen.dart';
import 'bucket_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countryProvider);
    final search = ref.watch(searchProvider);
    final isAscending = ref.watch(sortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Explorer"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isAscending ? Icons.sort_by_alpha : Icons.sort,
            ),
            tooltip: isAscending ? "Sort Z-A" : "Sort A-Z",
            onPressed: () {
              ref.read(sortProvider.notifier).state = !isAscending;
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
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
            return country.name
                .toLowerCase()
                .contains(search.toLowerCase());
          }).toList();

          filteredCountries.sort((a, b) {
            return isAscending
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name);
          });

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
                child: filteredCountries.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 70,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "No countries found",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(countryProvider);
                          await ref.read(countryProvider.future);
                        },
                        child: ListView.builder(
                          itemCount: filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = filteredCountries[index];

                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsScreen(
                                      country: country,
                                    ),
                                  ),
                                );
                              },
                              leading: Image.network(
                                country.flag,
                                width: 50,
                                height: 35,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(Icons.public);
                                },
                              ),
                              title: Text(country.name),
                              subtitle: Text(country.capital),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}