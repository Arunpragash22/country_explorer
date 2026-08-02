import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bucket_provider.dart';

class BucketScreen extends ConsumerWidget {
  const BucketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucket = ref.watch(bucketProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bucket List"),
      ),
      body: bucket.isEmpty
          ? const Center(
              child: Text("No Saved Countries"),
            )
          : ListView.builder(
              itemCount: bucket.length,
              itemBuilder: (context, index) {
                final country = bucket[index];

                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(country),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(bucketProvider.notifier)
                          .removeCountry(country);
                    },
                  ),
                );
              },
            ),
    );
  }
}