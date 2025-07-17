import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/add_product_page_provider.dart';
import '../widgets/my_text_form_field.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late AddProductPageProvider _provider;

  @override
  void initState() {
    super.initState();

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    _provider = AddProductPageProvider(productProvider: productProvider);
  }

  @override
  void dispose() {
    _provider.dispose();
    _provider.disposeTextEditControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<AddProductPageProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text(
                'Add Product',
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
                            final success = await provider.submitAdd(context);
                            if (success && context.mounted) {
                              // Safe only if widget still exists
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text('Add Product'),
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
