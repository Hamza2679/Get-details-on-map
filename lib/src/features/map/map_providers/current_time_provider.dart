import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StateProvider<String>((ref) {
  return 'Tap on the map to get the current time.';
});
