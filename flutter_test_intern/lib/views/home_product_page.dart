import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class HomeProductPage extends StatefulWidget {
  const HomeProductPage({super.key});

  @override
  State<HomeProductPage> createState() => _HomeProductPageState();
}

class _HomeProductPageState extends State<HomeProductPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProducts();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim().toLowerCase();

      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).filterProductsByName(query);
    });
  }

  Future<void> _refreshProducts() async {
    await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Products CRUD',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // export pdf
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.amber),
            onPressed: () {
              Provider.of<ProductProvider>(
                context,
                listen: false,
              ).exportProductsToPdf(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // search product by name
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // filter product
          Row(
            children: [
              const SizedBox(width: 10),
              const Text("Sort by: "),
              const SizedBox(width: 10),
              DropdownButton<SortType>(
                value: context.watch<ProductProvider>().selectedSort,
                hint: const Text("Select"),
                onChanged: (value) {
                  if (value != null) {
                    context.read<ProductProvider>().sortProducts(value);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: SortType.priceAsc,
                    child: Text("Price ↑"),
                  ),
                  DropdownMenuItem(
                    value: SortType.priceDesc,
                    child: Text("Price ↓"),
                  ),
                  DropdownMenuItem(
                    value: SortType.stockAsc,
                    child: Text("Stock ↑"),
                  ),
                  DropdownMenuItem(
                    value: SortType.stockDesc,
                    child: Text("Stock ↓"),
                  ),
                ],
              ),
            ],
          ),

          // show product as listview
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.products.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Icon(Icons.error, size: 50, color: Colors.red),
                        Text(
                          'No products available',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];

                      return Column(
                        children: [
                          const Divider(height: 1),
                          ListTile(
                            key: ValueKey(product.productId),
                            title: Text(product.productName),
                            subtitle: Text(
                              'Price: \$${product.price} | Stock: ${product.stock}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EditProductPage(
                                              product: product,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _confirmDelete(
                                        context,
                                        product.productId,
                                        product.productName,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Divider
                          const Divider(height: 1),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String productName) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete this product >> $productName?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  ).deleteProduct(context, id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
