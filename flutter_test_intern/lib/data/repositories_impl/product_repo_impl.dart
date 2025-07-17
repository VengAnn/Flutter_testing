import '../../models/product/product_list_res.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_res.dart';
import '../../utils/app_constant.dart';
import '../api/api_client.dart';
import '../repositories/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<ProductListRes> getAllProducts() async {
    final response = await _apiClient.get(AppConstant.endpointProduct);
    return ProductListRes.fromJson(response.data);
  }

  @override
  Future<ProductRes> getProductById(int id) async {
    final response = await _apiClient.get('${AppConstant.endpointProduct}/$id');
    return ProductRes.fromJson(response.data);
  }

  @override
  Future<ProductRes> createProduct(ProductModel product) async {
    final response = await _apiClient.post(
      AppConstant.endpointProduct,
      data: product.toJson(),
    );
    return ProductRes.fromJson(response.data);
  }

  @override
  Future<ProductRes> updateProduct(int id, ProductModel product) async {
    final response = await _apiClient.put(
      '${AppConstant.endpointProduct}/$id',
      data: product.toJson(),
    );
    return ProductRes.fromJson(response.data);
  }

  @override
  Future<ProductRes> deleteProduct(int id) async {
    final response = await _apiClient.delete(
      '${AppConstant.endpointProduct}/$id',
    );
    return ProductRes.fromJson(response.data);
  }
}
