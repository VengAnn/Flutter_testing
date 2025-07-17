class ProductModel {
  final int productId;
  final String productName;
  final double price;
  final int stock;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['PRODUCTID'],
      productName: json['PRODUCTNAME'],
      price: (json['PRICE'] as num).toDouble(),
      stock: json['STOCK'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PRODUCTID': productId,
      'PRODUCTNAME': productName,
      'PRICE': price,
      'STOCK': stock,
    };
  }
}
