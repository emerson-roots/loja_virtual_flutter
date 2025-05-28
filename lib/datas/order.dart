import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/Produto.dart';

class OrderModel {
  final String id;
  final String clientId;
  final double totalPrice;
  final double productsPrice;
  final double shipPrice;
  final int status;
  final List<OrderProduct> products;

  OrderModel({
    required this.id,
    required this.clientId,
    required this.totalPrice,
    required this.productsPrice,
    required this.shipPrice,
    required this.status,
    required this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      clientId: json['clientId'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      productsPrice: (json['productsPrice'] as num).toDouble(),
      shipPrice: (json['shipPrice'] as num).toDouble(),
      status: json['status'],
      products: (json['products'] as List)
          .map((item) => OrderProduct.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'totalPrice': totalPrice,
      'productsPrice': productsPrice,
      'shipPrice': shipPrice,
      'status': status,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final enrichedData = {
      'id': doc.id,// add o id firebase do documento ao objeto
      ...data,
    };
    return OrderModel.fromJson(enrichedData);
  }
}




