import 'package:flutter/material.dart';
import 'package:state_management_with_rxdart/recipes/ui/recipes_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipesPage(),
    );
  }
}