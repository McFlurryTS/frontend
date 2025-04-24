class MenuOption {
  final int id;
  final String name;
  final String description;
  final String category;
  final String price;

  MenuOption({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
  });

  factory MenuOption.fromJson(Map<String, dynamic> json) {
    return MenuOption(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'],
      price: json['price'],
    );
  }
}

class MenuCategory {
  final String message;
  final String category;
  final List<MenuOption> options;

  MenuCategory({
    required this.message,
    required this.category,
    required this.options,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      message: json['message'],
      category: json['category'],
      options:
          (json['options'] as List)
              .map((option) => MenuOption.fromJson(option))
              .toList(),
    );
  }
}
