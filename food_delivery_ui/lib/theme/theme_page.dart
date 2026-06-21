import 'package:flutter/material.dart';
import 'package:food_delivery_ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget{
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return SwitchListTile.adaptive(
            secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,),
            title: Text("Dark Mode"),
            subtitle: Text("Change theme mode"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          );
        },
      ),
    );
  }
}