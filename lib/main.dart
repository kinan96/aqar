import 'package:aqar/model/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'view/splash.dart';
void main() {
       WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
GlobalKey<NavigatorState>nav=GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aqar',
      navigatorKey: nav,
      theme: appTheme(),
      locale: Locale("en","US"),
      debugShowCheckedModeBanner: false,
      home: Splash(title: "aqar",nav: nav,),
      supportedLocales: [
        Locale( 'en' , 'US' ),
        Locale( 'ar' , 'SA' ),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}