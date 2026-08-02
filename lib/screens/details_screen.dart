import 'package:flutter/material.dart';
import '../models/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bucket_provider.dart';
import '../providers/notes_provider.dart';
class DetailsScreen extends ConsumerWidget {
  final Country country;

  const DetailsScreen({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucket = ref.watch(bucketProvider);
    final isSaved = bucket.contains(country.name);
    final note = ref.watch(notesProvider)[country.name] ?? "";
    final controller = TextEditingController(text: note);
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        centerTitle: true,
        actions: [
            IconButton(
            icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
            ),
            onPressed: () {
                if (isSaved) {
                ref.read(bucketProvider.notifier).removeCountry(country.name);
                } else {
                ref.read(bucketProvider.notifier).addCountry(country.name);
                }
            },
            ),
        ],
     ),
            body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.network(
              country.flag,
              width: 220,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.public, size: 120);
              },
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Country"),
                subtitle: Text(country.name),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_city),
                title: const Text("Capital"),
                subtitle: Text(country.capital),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("Currency"),
                subtitle: Text(country.currency),
                ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Phone Code"),
                subtitle: Text(country.phone),
                ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Population"),
                subtitle: Text(country.population.toString()),
                ),
            ),
            const SizedBox(height: 20),

            Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                labelText: "Personal Notes",
                hintText: "Write your travel notes...",
                border: OutlineInputBorder(),
                ),
                
              ),
            ),
            const SizedBox(height: 10),

                ElevatedButton.icon(
                onPressed: () {
                    ref.read(notesProvider.notifier).saveNote(
                    country.name,
                    controller.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Note Saved"),
                    ),
                    );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Note"),
         ),
          ],
        ),
      ),
    );
  }
}