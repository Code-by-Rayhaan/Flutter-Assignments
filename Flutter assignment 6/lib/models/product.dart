class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;
  final String brand;
  final bool isFavorite;
  final bool inStock;
  final List<String> tags;
  final Map<String, String> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
    required this.brand,
    this.isFavorite = false,
    this.inStock = true,
    this.tags = const [],
    this.specifications = const {},
  });

  String get formattedPrice => '₹${_formatIndianNumber(price.round())}';
  String get formattedRating => rating.toStringAsFixed(1);

  static String _formatIndianNumber(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    var result = '';
    while (rest.length > 2) {
      result = ',${rest.substring(rest.length - 2)}$result';
      rest = rest.substring(0, rest.length - 2);
    }
    return '$rest$result,$last3';
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? rating,
    int? reviewCount,
    String? description,
    String? imageUrl,
    String? brand,
    bool? isFavorite,
    bool? inStock,
    List<String>? tags,
    Map<String, String>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      isFavorite: isFavorite ?? this.isFavorite,
      inStock: inStock ?? this.inStock,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
