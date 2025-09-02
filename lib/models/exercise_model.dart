class Exercise {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String benefits;
  final List<String> steps;

  Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.benefits,
    this.steps = const [],
  });
}