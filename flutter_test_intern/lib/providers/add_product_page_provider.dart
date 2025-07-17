// providers/add_product_page_provider.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/product/product_model.dart';
import '../providers/product_provider.dart';

class AddProductPageProvider extends ChangeNotifier {
  final ProductProvider productProvider;

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AddProductPageProvider({required this.productProvider});

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

  Future<bool> submitAdd(BuildContext context) async {
    if (!formKey.currentState!.validate()) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = ProductModel(
        productId: DateTime.now().millisecondsSinceEpoch,
        productName: nameController.text.trim(),
        price: double.parse(priceController.text),
        stock: int.parse(stockController.text),
      );

      await productProvider.createProduct(context, newProduct);

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
