import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortProvider = StateProvider<bool>((ref) => true);
// true = A-Z
// false = Z-A