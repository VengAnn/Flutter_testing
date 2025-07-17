import 'package:flutter/material.dart';

import 'data/repositories_impl/product_repo_impl.dart';
import 'providers/product_provider.dart';
import 'views/home_product_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductRepositoryImpl()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Testing Intern',
      home: const HomeProductPage(),
    );
  }
}
