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
import 'providers/business_provider.dart';
import 'providers/fabric_provider.dart';
import 'providers/measurement_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/localization/app_localizations.dart';
import 'utils/localization/localization_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await LocalizationManager().initialize();

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

class BespokeAtelierApp extends StatefulWidget {
  final bool startLoggedIn;
  const BespokeAtelierApp({super.key, this.startLoggedIn = false});

  @override
  State<BespokeAtelierApp> createState() => _BespokeAtelierAppState();
}

class _BespokeAtelierAppState extends State<BespokeAtelierApp> {
  late final ValueNotifier<Locale> _localeNotifier;

  @override
  void initState() {
    super.initState();
    _localeNotifier = LocalizationManager().localeNotifier;
    _localeNotifier.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    _localeNotifier.removeListener(_onLocaleChanged);
    super.dispose();
  }

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
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => FabricProvider()),
        ChangeNotifierProvider(create: (_) => MeasurementProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        title: 'The Bespoke Atelier',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        locale: _localeNotifier.value,
        supportedLocales: LocalizationManager.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // The splash screen will handle the redirection after the branding timer
        home: SplashScreen(startLoggedIn: widget.startLoggedIn),
      ),
    );
  }
}
