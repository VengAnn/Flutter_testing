import 'package:flutter_test_intern/models/product/product_model.dart';

import '../../models/product/product_list_res.dart';
import '../../models/product/product_res.dart';

abstract class ProductRepository {
  Future<ProductListRes> getAllProducts();
  Future<ProductRes> getProductById(int id);
  Future<ProductRes> createProduct(ProductModel product);
  Future<ProductRes> updateProduct(int id, ProductModel product);
  Future<ProductRes> deleteProduct(int id);
}
