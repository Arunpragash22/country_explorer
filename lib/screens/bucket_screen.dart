import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bucket_provider.dart';
import '../providers/country_provider.dart';
import 'details_screen.dart';

class BucketScreen extends ConsumerWidget {
  const BucketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucket = ref.watch(bucketProvider);
    final countriesAsync = ref.watch(countryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bucket List"),
      ),
      body: bucket.isEmpty
          ? const Center(
              child: Text("No Saved Countries"),
            )
          : countriesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text("Error: $error"),
              ),
              data: (countries) {
                final bucketCountries = countries
                    .where(
                      (country) => bucket.contains(country.name),
                    )
                    .toList();

                return ListView.builder(
                  itemCount: bucketCountries.length,
                  itemBuilder: (context, index) {
                    final country = bucketCountries[index];

                    return ListTile(
                      leading: Image.network(
                        country.flag,
                        width: 50,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(Icons.public);
                        },
                      ),

                      title: Text(country.name),

                      subtitle: Text(country.capital),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref
                              .read(bucketProvider.notifier)
                              .removeCountry(country.name);
                        },
                      ),

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
                    );
                  },
                );
              },
            ),
    );
  }
}