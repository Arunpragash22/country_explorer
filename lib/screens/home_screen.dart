import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../providers/sort_provider.dart';
import '../providers/country_provider.dart';
import '../providers/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'details_screen.dart';
import 'bucket_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countryProvider);
    final search = ref.watch(searchProvider);
    final isAscending = ref.watch(sortProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Explorer"),
        centerTitle: true,
        actions: [

          // Dark Mode Toggle
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: themeMode == ThemeMode.dark
                ? "Light Mode"
                : "Dark Mode",
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),

          // Sort A-Z / Z-A
          IconButton(
            icon: Icon(
              isAscending
                  ? Icons.sort_by_alpha
                  : Icons.sort,
            ),
            tooltip: isAscending ? "Sort Z-A" : "Sort A-Z",
            onPressed: () {
              ref.read(sortProvider.notifier).state =
                  !isAscending;
            },
          ),

          // Favorite / Bucket List
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

        // Loading
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // Error
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 70,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              const Text(
                "Unable to load countries",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please check your internet connection.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(countryProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),

        // Data
        data: (countries) {

          final filteredCountries = countries.where((country) {
            return country.name
                .toLowerCase()
                .contains(search.toLowerCase());
          }).toList();

          // Sorting
          filteredCountries.sort((a, b) {
            return isAscending
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name);
          });

          return Column(
            children: [

              // Search Field
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search Country...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    ref
                        .read(searchProvider.notifier)
                        .state = value;
                  },
                ),
              ),

              // Country List
              Expanded(
                child: filteredCountries.isEmpty

                    // No Results
                    ? const Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
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

                    // Country List + Pull to Refresh
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(countryProvider);

                          await ref.read(
                            countryProvider.future,
                          );
                        },

                        child: ListView.builder(
                          itemCount:
                              filteredCountries.length,

                          itemBuilder:
                              (context, index) {

                            final country =
                                filteredCountries[index];

                            return ListTile(

                              // Open Details
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailsScreen(
                                      country: country,
                                    ),
                                  ),
                                );
                              },

                              // Flag
                              leading: CachedNetworkImage(
                                imageUrl: country.flag,
                                width: 50,
                                height: 35,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return const SizedBox(
                                    width: 50,
                                    height: 35,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return const Icon(
                                    Icons.public,
                                  );
                                },
                              ),

                              // Country Name
                              title: Text(
                                country.name,
                              ),

                              // Capital
                              subtitle: Text(
                                country.capital,
                              ),
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