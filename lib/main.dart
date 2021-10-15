import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies/pages/home_page.dart';
import 'package:movies/services/movie_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

// ============================================================================
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieService(),
          lazy: false,
        )
      ],
      child: const MyApp(),
    );
  }
}

// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
      },
      theme: ThemeData.dark(),
    );
  }
}
