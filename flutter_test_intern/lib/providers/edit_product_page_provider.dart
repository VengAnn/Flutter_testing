// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/product/product_model.dart';
import '../providers/product_provider.dart';

class EditProductPageProvider extends ChangeNotifier {
  final ProductProvider productProvider;
  final ProductModel originalProduct;

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EditProductPageProvider({
    required this.productProvider,
    required this.originalProduct,
  }) {
    // Initialize controllers here (synchronously)
    nameController = TextEditingController(text: originalProduct.productName);
    priceController = TextEditingController(
      text: originalProduct.price.toString(),
    );
    stockController = TextEditingController(
      text: originalProduct.stock.toString(),
    );
  }

  String? validateName(String? val) =>
      val == null || val.trim().isEmpty ? 'Required' : null;

  String? validatePrice(String? val) {
    if (val == null || val.trim().isEmpty) return 'Required';
    final parsed = double.tryParse(val);
    if (parsed == null || parsed <= 0) return 'Enter valid price';
    return null;
  }

  String? validateStock(String? val) {
    if (val == null || val.trim().isEmpty) return 'Required';
    final parsed = int.tryParse(val);
    if (parsed == null || parsed < 0) return 'Enter valid stock';
    return null;
  }

  Future<bool> submitEdit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedProduct = ProductModel(
        productId: originalProduct.productId,
        productName: nameController.text.trim(),
        price: double.parse(priceController.text),
        stock: int.parse(stockController.text),
      );

      await productProvider.updateProduct(
        context,
        originalProduct.productId,
        updatedProduct,
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void disposeTextEditControllers() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
