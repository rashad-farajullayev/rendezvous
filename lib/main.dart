import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rendezvous/constants.dart';
import 'package:rendezvous/screens/login/ChooseUserNameScreen.dart';
import 'package:rendezvous/screens/login/CodeVerificationScreen.dart';
import 'package:rendezvous/screens/login/LoginScreen.dart';
import 'screens/MainScreen.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/providers/AuthenticationProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static Color statusBarColorLight = Colors.grey[50];
  static Color statusBarColorDark = Color(0xff0D0D0D);

  static Color navigationBarColorLight = Colors.white;
  static Color navigationBarColorDark = Color(0xff0D0D0D);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness _brightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_brightness == null)
      _brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .platformBrightness;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // _pageController.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    setState(() {
      _brightness = brightness;
    });

    _updateNavigationColors();
  }

  void _updateNavigationColors() {
    if (_brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: MyApp.navigationBarColorDark,
        statusBarColor: MyApp.statusBarColorDark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: MyApp.navigationBarColorLight,
        statusBarColor: MyApp.statusBarColorLight,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateNavigationColors();

    return ChangeNotifierProvider(
      create: (providerContext) => AuthenticationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .platformBrightness ==
                Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark,
        title: StringConstants.APPLICATION_TITLE,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Colors.blue[500],
          primaryColor: Color(0xff2B5FF6),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
            headline1: TextStyle(color: Colors.white),
            headline2: TextStyle(color: Colors.white),
            headline3: TextStyle(color: Colors.white),
            headline4: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w200,
            ),
            headline5: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w200,
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogBackgroundColor: Color(0xff292E30),
          appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
              color: MyApp.statusBarColorDark,
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true),
          scaffoldBackgroundColor: Color(0xff202020),
          dividerColor: Color(0xff3D4043),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[700],
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            backgroundColor: MyApp.navigationBarColorDark,
            elevation: 0.0,
          ),
        ),
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
              buttonColor: Color(0xff486CD6), disabledColor: Colors.grey[200]),
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff486CD6),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.grey[900]),
            bodyText2: TextStyle(color: Colors.grey[900]),
            headline1: TextStyle(color: Colors.grey[900]),
            headline2: TextStyle(color: Colors.grey[900]),
            headline3: TextStyle(color: Colors.grey[900]),
            headline4: TextStyle(color: Colors.grey[900]),
            headline5: TextStyle(color: Colors.grey[900]),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: MyApp.statusBarColorLight,
            iconTheme: IconThemeData(color: Colors.grey[900]),
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
          dividerColor: Colors.grey[300],
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Color(0xff486CD6),
            unselectedItemColor: Colors.grey[800],
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            backgroundColor: MyApp.navigationBarColorLight,
            elevation: 0.0,
          ),
        ),
        initialRoute: MainScreen.ROUTE_PATH,
        routes: {
          "/": (ctx) => MainScreen(),
          MainScreen.ROUTE_PATH: (ctx) => MainScreen(),
          LoginScreen.ROUTE_PATH: (ctx) => LoginScreen(),
          CodeVerificationScreen.ROUTE_PATH: (ctx) => CodeVerificationScreen(),
          ChooseUserNameScreen.ROUTE_PATH: (ctx) => ChooseUserNameScreen()
        },
      ),
    );
  }
}
