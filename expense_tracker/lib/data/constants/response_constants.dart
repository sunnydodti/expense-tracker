import 'dart:math';

class ResponseConstants {
  static UpcomingFeature upcoming = UpcomingFeature();
}

class UpcomingFeature {
  static const List<String> _messages = [
    "New horizons await! Coming soon.",
    "Exciting updates ahead! Stay tuned.",
    "Exploring new realms! Coming soon.",
    "Discoveries in progress! Coming soon.",
    "Venturing into the unknown! Stay tuned.",
    "Navigating uncharted waters! Coming soon.",
    "Journeying into new territory! Stay tuned.",
    "Embarking on a new quest! Coming soon.",
    "Venturing into unexplored territory! Stay tuned."
  ];

  String get getRandomMessage {
    final random = Random();
    return _messages[random.nextInt(_messages.length)];
  }
}
