class Product {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>?;
    return Product(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      price: (json['price'] as num).toDouble(),
      imageUrl: (json['image'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      rating: (rating != null ? (rating['rate'] as num?)?.toDouble() : null) ?? 0.0,
      ratingCount: (rating != null ? (rating['count'] as num?)?.toInt() : null) ?? 0,
    );
  }
}


