import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final bucketProvider =
    StateNotifierProvider<BucketNotifier, List<String>>((ref) {
  return BucketNotifier();
});

class BucketNotifier extends StateNotifier<List<String>> {
  BucketNotifier() : super([]) {
    loadBucket();
  }

  final box = Hive.box('bucketBox');

  void loadBucket() {
    state = List<String>.from(box.get('countries', defaultValue: []));
  }

  void addCountry(String country) {
    if (!state.contains(country)) {
      state = [...state, country];
      box.put('countries', state);
    }
  }


  void removeCountry(String country) {
    state = state.where((e) => e != country).toList();
    box.put('countries', state);
  }

  bool isSaved(String country) {
    return state.contains(country);
  }
}