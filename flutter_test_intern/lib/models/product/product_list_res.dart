import 'product_model.dart';

class ProductListRes {
  final bool success;
  final List<ProductModel> data;

  ProductListRes({required this.success, required this.data});

  factory ProductListRes.fromJson(Map<String, dynamic> json) {
    return ProductListRes(
      success: json['success'],
      data: List<ProductModel>.from(
        json['data'].map((item) => ProductModel.fromJson(item)),
      ),
    );
  }
}
