import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/session_manager.dart';
import 'providers/login_provider.dart';
import 'providers/home_provider.dart';
import 'providers/order_management_provider.dart';
import 'providers/clients_provider.dart';
import 'providers/package_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Determine if the user already has a saved session
  final isLoggedIn = await SessionManager.instance.isLoggedIn();

  runApp(BespokeAtelierApp(startLoggedIn: isLoggedIn));
}

class BespokeAtelierApp extends StatelessWidget {
  final bool startLoggedIn;
  const BespokeAtelierApp({super.key, this.startLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => OrderManagementProvider()),
        ChangeNotifierProvider(create: (_) => ClientsProvider()),
        ChangeNotifierProvider(create: (_) => PackageProvider()),
      ],
      child: MaterialApp(
        title: 'The Bespoke Atelier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        // If the user was already logged in (token saved), skip the login screen
        home: startLoggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }
}
