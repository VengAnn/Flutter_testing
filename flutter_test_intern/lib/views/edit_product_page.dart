import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/edit_product_page_provider.dart';
import '../widgets/my_text_form_field.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late EditProductPageProvider _provider;

  @override
  void initState() {
    super.initState();

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    _provider = EditProductPageProvider(
      productProvider: productProvider,
      originalProduct: widget.product,
    );
  }

  @override
  void dispose() {
    _provider.dispose();
    _provider.disposeTextEditControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider.value to provide _provider already created in initState
    return ChangeNotifierProvider<EditProductPageProvider>.value(
      value: _provider,
      child: Consumer<EditProductPageProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text(
                'Edit Product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: provider.formKey,
                child: Column(
                  children: [
                    MyTextFormField(
                      controller: provider.nameController,
                      label: 'Product Name',
                      validator: provider.validateName,
                    ),
                    MyTextFormField(
                      controller: provider.priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      validator: provider.validatePrice,
                    ),
                    MyTextFormField(
                      controller: provider.stockController,
                      label: 'Stock',
                      keyboardType: TextInputType.number,
                      validator: provider.validateStock,
                    ),
                    const SizedBox(height: 20),
                    provider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            final success = await provider.submitEdit(context);
                            if (success && context.mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text('Save Changes'),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
