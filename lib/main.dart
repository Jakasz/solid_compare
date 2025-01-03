import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_compare_img/presentation/pages/home_page.dart';
import 'package:solid_compare_img/presentation/providers/comparison_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ComparisonProvider()),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
