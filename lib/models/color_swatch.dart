class ColorSwatch {
  final String name;
  final String hex;

  const ColorSwatch({required this.name, required this.hex});

  factory ColorSwatch.fromJson(Map<String, dynamic> json) {
    return ColorSwatch(
      name: json['name'] as String? ?? '',
      hex: json['hex'] as String? ?? '#000000',
    );
  }
}
