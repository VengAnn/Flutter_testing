import 'package:flutter_test_intern/models/product/product_model.dart';

class ProductRes {
  final bool success;
  final ProductModel? productData;
  final String? message;

  ProductRes({required this.success, this.productData, this.message});

  factory ProductRes.fromJson(Map<String, dynamic> json) {
    return ProductRes(
      success: json['success'],
      productData:
          json['data'] != null ? ProductModel.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}
