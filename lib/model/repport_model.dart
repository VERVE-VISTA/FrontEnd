class Report {
  final String reporter;
  final String advisor;
  final String description;

  Report({
    required this.reporter,
    required this.advisor,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'reporter': reporter,
        'advisor': advisor,
        'description': description,
      };
}
