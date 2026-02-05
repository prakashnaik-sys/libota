import 'availability_source.dart';

class AvailabilityResult {
  final AvailabilitySource source;
  final String label;
  final String url;

  AvailabilityResult({
    required this.source,
    required this.label,
    required this.url,
  });
}
