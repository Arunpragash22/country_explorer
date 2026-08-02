import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, Map<String, String>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<Map<String, String>> {
  NotesNotifier() : super({}) {
    loadNotes();
  }

  final box = Hive.box('bucketBox');

  void loadNotes() {
    final data = Map<String, String>.from(
      box.get('notes', defaultValue: {}),
    );
    state = data;
  }

  void saveNote(String country, String note) {
    final updated = {...state};
    updated[country] = note;

    state = updated;

    box.put('notes', updated);
  }

  String getNote(String country) {
    return state[country] ?? "";
  }
}