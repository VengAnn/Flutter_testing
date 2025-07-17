// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../data/repositories/product_repo.dart';
import '../models/product/product_model.dart';
import '../models/product/product_res.dart';
import '../models/product/product_list_res.dart';
import '../utils/animation_snackbar.dart';

// For working with files like creating and writing the PDF
import 'dart:io';

// For opening the generated PDF with a default viewer (e.g. Files, iBooks, etc.)
import 'package:open_file/open_file.dart';

// For getting the device's documents directory to save the PDF
import 'package:path_provider/path_provider.dart';

// For generating and manipulating PDF files (title, content, fonts, etc.)
import 'package:syncfusion_flutter_pdf/pdf.dart';

enum SortType { priceAsc, priceDesc, stockAsc, stockDesc }

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProductProvider(this._repository);

  // Fetch all products
  Future<void> fetchAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final ProductListRes result = await _repository.getAllProducts();
      _allProducts = result.data;
      _products = _allProducts;
    } catch (e) {
      debugPrint('Fetch products failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter products by productName
  void filterProductsByName(String query) {
    if (query.isEmpty) {
      _products = _allProducts;
    } else {
      _products =
          _allProducts
              .where(
                (p) =>
                    p.productName.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  // Create new product
  Future<void> createProduct(BuildContext context, ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ProductRes result = await _repository.createProduct(product);

      if (result.success) {
        if (result.productData != null) {
          _products.add(result.productData!);
        }
        notifyListeners();

        AnimationSnackbarComponent.showSuccess(
          context,
          'Success',
          'Product created successfully',
        );
      } else {
        AnimationSnackbarComponent.showError(
          context,
          'Create Failed',
          result.message.toString(),
        );
      }
    } catch (e) {
      debugPrint('Create failed: $e');
      AnimationSnackbarComponent.showError(
        context,
        'Error',
        'Failed to create product. Please try again.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update product
  Future<void> updateProduct(
    BuildContext context,
    int id,
    ProductModel product,
  ) async {
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();

    try {
      final ProductRes result = await _repository.updateProduct(id, product);

      if (result.success) {
        // Update product in local list
        final index = _products.indexWhere((p) => p.productId == id);
        if (index != -1) {
          _products[index] = result.productData!;
          notifyListeners();
        }

        AnimationSnackbarComponent.showSuccess(
          context,
          'Success',
          'Product updated successfully',
        );
      } else {
        AnimationSnackbarComponent.showError(
          context,
          'Update Failed',
          result.message.toString(),
        );
      }
    } catch (e) {
      debugPrint('Update failed: $e');
      AnimationSnackbarComponent.showError(
        context,
        'Error',
        'Failed to update product: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete product
  Future<void> deleteProduct(BuildContext context, int id) async {
    try {
      final ProductRes result = await _repository.deleteProduct(id);

      if (result.success) {
        _products.removeWhere((p) => p.productId == id);
        notifyListeners();

        AnimationSnackbarComponent.showSuccess(
          context,
          'Success',
          'Product deleted successfully',
        );
      } else {
        AnimationSnackbarComponent.showError(
          context,
          'Delete Failed',
          result.message.toString(),
        );
      }
    } catch (e) {
      debugPrint('Delete failed: $e');
      AnimationSnackbarComponent.showError(
        context,
        'Error',
        'Failed to delete product: $e',
      );
    }
  }

  SortType? _selectedSort;
  SortType? get selectedSort => _selectedSort;
  // Sort products
  void sortProducts(SortType type) {
    _selectedSort = type;
    switch (type) {
      case SortType.priceAsc:
        _products.sort((a, b) => a.price.compareTo(b.price));
        // Sort by price from low to high
        break;
      case SortType.priceDesc:
        _products.sort((a, b) => b.price.compareTo(a.price));
        // Sort by price from high to low
        break;
      case SortType.stockAsc:
        _products.sort((a, b) => a.stock.compareTo(b.stock));
        // Sort by stock from low to high
        break;
      case SortType.stockDesc:
        _products.sort((a, b) => b.stock.compareTo(a.stock));
        // Sort by stock from low to high
        break;
    }
    notifyListeners();
  }

  //
  Future<void> exportProductsToPdf(BuildContext context) async {
    try {
      final PdfDocument document = PdfDocument();
      PdfPage page = document.pages.add();
      PdfGraphics graphics = page.graphics;

      final PdfFont fontTitle = PdfStandardFont(
        PdfFontFamily.helvetica,
        18,
        style: PdfFontStyle.bold,
      );
      final PdfFont fontContent = PdfStandardFont(PdfFontFamily.helvetica, 12);
      double y = 0;

      graphics.drawString(
        'Product List',
        fontTitle,
        bounds: Rect.fromLTWH(0, y, 500, 30),
      );
      y += 40;

      graphics.drawString(
        'Name',
        fontContent,
        bounds: Rect.fromLTWH(0, y, 200, 20),
      );
      graphics.drawString(
        'Price',
        fontContent,
        bounds: Rect.fromLTWH(200, y, 100, 20),
      );
      graphics.drawString(
        'Stock',
        fontContent,
        bounds: Rect.fromLTWH(300, y, 100, 20),
      );
      y += 20;

      for (var p in _products) {
        if (y > page.getClientSize().height - 20) {
          page = document.pages.add();
          graphics = page.graphics;
          y = 20;
        }

        graphics.drawString(
          p.productName,
          fontContent,
          bounds: Rect.fromLTWH(0, y, 200, 20),
        );
        graphics.drawString(
          '\$${p.price.toStringAsFixed(2)}',
          fontContent,
          bounds: Rect.fromLTWH(200, y, 100, 20),
        );
        graphics.drawString(
          '${p.stock}',
          fontContent,
          bounds: Rect.fromLTWH(300, y, 100, 20),
        );
        y += 20;
      }

      final List<int> bytes = await document.save();
      document.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/products_export.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (context.mounted) {
        debugPrint('PDF exported to $filePath');
        AnimationSnackbarComponent.showSuccess(
          context,
          'Success',
          'PDF exported successfully',
        );

        // 👇 Auto-open the PDF after export
        await OpenFile.open(file.path);
      }
    } catch (e) {
      debugPrint('PDF export error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to export PDF')));
      }
    }
  }
}
