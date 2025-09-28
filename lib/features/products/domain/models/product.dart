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
      rating:
          (rating != null ? (rating['rate'] as num?)?.toDouble() : null) ?? 0.0,
      ratingCount:
          (rating != null ? (rating['count'] as num?)?.toInt() : null) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': imageUrl,
      'description': description,
      'category': category,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.category == category &&
        other.rating == rating &&
        other.ratingCount == ratingCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        category.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode;
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    String? category,
    double? rating,
    int? ratingCount,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, imageUrl: $imageUrl, description: $description, category: $category, rating: $rating, ratingCount: $ratingCount)';
  }
}
