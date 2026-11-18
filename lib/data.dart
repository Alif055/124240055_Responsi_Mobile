
class Product {
  final int id;
  final String title, description, category, image;
  final double price, rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        category: j['category'] ?? '',
        image: j['image'] ?? '',
        price: (j['price'] as num).toDouble(),
        rating: ((j['rating']?['rate']) ?? 0 as num).toDouble(),
        ratingCount: ((j['rating']?['count']) ?? 0 as num).toInt(),
      );

  Map<String, dynamic> toCartMap(String username) => {
        'username': username,
        'productId': id,
        'title': title,
        'price': price,
        'image': image,
        'rating': rating,
        'ratingCount': ratingCount,
      };
}
