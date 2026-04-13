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
import 'providers/profile_provider.dart';
import 'providers/staff_provider.dart';
import 'providers/fabric_provider.dart';
import 'providers/measurement_provider.dart';
import 'screens/splash/splash_screen.dart';

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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => FabricProvider()),
        ChangeNotifierProvider(create: (_) => MeasurementProvider()),
      ],
      child: MaterialApp(
        title: 'The Bespoke Atelier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        // The splash screen will handle the redirection after the branding timer
        home: SplashScreen(startLoggedIn: startLoggedIn),
      ),
    );
  }
}
