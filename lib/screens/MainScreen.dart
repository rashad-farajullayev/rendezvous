import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';

import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/providers/AuthenticationProvider.dart';
import 'package:rendezvous/models/User.dart';
import 'package:rendezvous/screens/profile/SimpleProfileScreen.dart';
import '../constants.dart';

class MainScreen extends StatefulWidget {
  static const String ROUTE_PATH = "/main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  int _previousPage = 0;
  User _currentUser;
  LiquidController _liquidController = LiquidController();

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<AuthenticationProvider>(context).currentUser;

    return Scaffold(
      body: LiquidSwipe(
        enableLoop: true,
        waveType: WaveType.liquidReveal,
        pages: [
          Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(child: Text("Home Page"))),
          Container(
              decoration: BoxDecoration(color: Colors.purple),
              child: Center(child: Text("Browse"))),
          Container(
              decoration: BoxDecoration(color: Colors.green),
              child: Center(child: Text("Add"))),
          Container(
              decoration: BoxDecoration(color: Colors.orange),
              child: Center(child: Text("Meetings"))),
          SimpleProfileScreen(),
        ],
        onPageChangeCallback: onPageChanged,
        liquidController: _liquidController,
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        title: FractionallySizedBox(
          widthFactor:
              (MediaQuery.of(context).orientation == Orientation.portrait
                  ? 0.4
                  : 0.2),
          child: SvgPicture.asset(AssetConstants.LOGO_SVG,
              color: Theme.of(context).appBarTheme.iconTheme.color,
              semanticsLabel: StringConstants.APPLICATION_TITLE),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).navigationRailTheme.backgroundColor,
          border: Border(
              top: BorderSide(width: 1, color: Theme.of(context).dividerColor)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: createNavigationTabs(context),
          onTap: (pageIndex) => navigationTapped(pageIndex),
          currentIndex: _page,
        ),
      ),
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPageChanged(int page) {
    if (page == 4 && !isAuthenticated) {
      _liquidController.animateToPage(page: _previousPage, duration: 100);
      setState(() {
        _page = _previousPage;
      });
      return;
    }

    setState(() {
      this._previousPage = _page;
      this._page = page;
    });
  }

  dynamic createNavigationTabs(BuildContext context) {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.home),
        ),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.explore),
        ),
        label: "Explore",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.add_box,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
        label: "",
      ),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(Icons.calendar_today),
          ),
          label: "Meetings",
          backgroundColor: Colors.white),
      BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(Icons.person),
          ),
          label: "Profile",
          backgroundColor: Colors.white),
    ];
  }

  void navigationTapped(int page) {
    if (page == 4 && !isAuthenticated) {
      _liquidController.animateToPage(page: _previousPage, duration: 100);
      setState(() {
        _page = _previousPage;
      });
      return;
    }

    _liquidController.animateToPage(page: page, duration: 200);
    setState(() {
      _previousPage = _page;
      _page = page;
    });
  }

  bool get isAuthenticated {
    if (_currentUser == null) {
      Provider.of<AuthenticationProvider>(context, listen: false)
          .openAuthenticationBox(context);
      Provider.of<AuthenticationProvider>(context, listen: false)
          .addListener(afterAuthentication);
      return false;
    }
    return true;
  }

  void afterAuthentication() {
    _currentUser =
        Provider.of<AuthenticationProvider>(context, listen: false).currentUser;
    if (_currentUser == null) return;
    _liquidController.animateToPage(page: 4);
    Provider.of<AuthenticationProvider>(context, listen: false)
        .removeListener(afterAuthentication);
    setState(() {
      _page = 4;
    });
  }
}
