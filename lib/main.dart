import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:depd_mvvm_2025/shared/style.dart';
import 'package:depd_mvvm_2025/view/pages/pages.dart';
import 'package:depd_mvvm_2025/viewmodel/home_viewmodel.dart';

Future<void> main() async {
  // Memastikan binding Flutter sudah diinisialisasi sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  // Memuat file .env sebelum diakses widget
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter x RajaOngkir API',
        theme: ThemeData(
          primaryColor: Style.blue800,
          scaffoldBackgroundColor: Style.grey50,
          textTheme: Theme.of(
            context,
          ).textTheme.apply(bodyColor: Style.black, displayColor: Style.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Style.blue800),
              foregroundColor: WidgetStateProperty.all<Color>(Style.white),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.all(16),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Style.blue800),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Style.grey500),
            floatingLabelStyle: TextStyle(color: Style.blue800),
            hintStyle: TextStyle(color: Style.grey500),
            iconColor: Style.grey500,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.grey500),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Style.blue800, width: 2),
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {'/': (context) => const HomePage()},
      ),
    );
  }
}
