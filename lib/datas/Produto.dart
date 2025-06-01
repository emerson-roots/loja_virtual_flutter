import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  List? images;
  List? sizes;

  Produto();

  Map<String, dynamic> toResumedMap() {
    return {"title": title, "description": description, "price": price};
  }

  Produto.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get('title');
    description = snapshot.get("description");
    price = snapshot.get("price") + 0.0;
    images = snapshot.get("images");
    sizes = snapshot.get("sizes");
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'sizes': sizes,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto()
      ..category = json['category']
      ..id = json['id']
      ..title = json['title']
      ..description = json['description']
      ..price = (json['price'] as num?)?.toDouble()
      ..images = json['images'] as List?
      ..sizes = json['sizes'] as List?;
  }
}

class OrderProduct {
  final Produto product;
  final int quantity;
  final String size;
  final String pid;
  final String category;

  OrderProduct({
    required this.product,
    required this.quantity,
    required this.size,
    required this.pid,
    required this.category,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      product: Produto.fromJson(json['product']),
      quantity: json['quantity'],
      size: json['size'],
      pid: json['pid'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toResumedMap(),
      'quantity': quantity,
      'size': size,
      'pid': pid,
      'category': category,
    };
  }
}
