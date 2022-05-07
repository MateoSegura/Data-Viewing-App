import 'dart:html';

import 'package:data_viewing_app/pages/homePage/homePage.dart';
import 'package:data_viewing_app/theme/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  if (kIsWeb) {
    window.document.onContextMenu.listen((evt) => evt.preventDefault());
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: true),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Changer',
      theme: themeProvider.getThemeData,
      home: HomePage(),
      // home: CollectionPage(
      //   title: "Electrical",
      // ),
    );
  }
}
