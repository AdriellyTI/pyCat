class Cat {
  final String name;
  final int ageYears;
  final String? imageUrl;
  final String? birthday;
  final String? breed;
  final List<String> vaccines;
  final bool isSelected;

  const Cat({
    required this.name,
    required this.ageYears,
    this.imageUrl,
    this.birthday,
    this.breed,
    this.vaccines = const [],
    this.isSelected = false,
  });
}
