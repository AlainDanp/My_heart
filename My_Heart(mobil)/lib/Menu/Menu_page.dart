import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_heart/Conseil/ConseilContent_page.dart';
import 'package:my_heart/Donantion/DontContent_page.dart';
import 'package:my_heart/Option/OptionContent_page.dart';
import 'package:my_heart/Programme/ProgrammeContent_page.dart';
import 'package:badges/badges.dart' as badges;

import '../Home/HomeContent_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<String> appBarTitles = [
    'Acceuil',
    'Conseil',
    'Programme',
    'Don',
    'Option',
  ];
  int currentPageIndex = 0;
  List<String> notifications = [
    // 'Nouveau Conseil',
    // 'Programme ajoute',
  ];

  int get notificationCount => notifications.length;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[currentPageIndex]),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Poppins"),
        actions: <Widget>[
          badges.Badge(
            badgeContent: Text(
              '$notificationCount',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            position: badges.BadgePosition.topEnd(top: 3, end: 5),
            child: IconButton(
              icon: const Icon(Icons.notifications_sharp, color: Colors.white),
              tooltip: 'Notification Icon',
              onPressed: () => openFullscreenDialog(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.comment, color: Colors.white),
            tooltip: 'Comment Icon',
            onPressed: () => openFullscreenHistorique(context),
          ),

        ],
        backgroundColor: Colors.red,
        elevation: 50.0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              tooltip: 'Menu Icon',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.red,
          indicatorColor: Colors.white,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined, color: Colors.white),
              label: 'Acceuil',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.comment),
              icon: Icon(Icons.comment_outlined, color: Colors.white),
              label: 'Conseil',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.reorder),
              icon: Icon(Icons.reorder_outlined, color: Colors.white),
              label: 'Programme',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.local_activity),
              icon: Icon(Icons.local_activity_outlined, color: Colors.white),
              label: 'Don',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined, color: Colors.white),
              label: 'Option',
            ),
          ],
        ),
      ),
      body: <Widget>[
        /// Home page
        const HomePageContent(),

        /// Conseil page
        const ConseilPageContent(),

        /// Programme Page
        const ProgrammePageContent(),

        /// Dont page
        const DontPageContent(),

        /// Messages page
        const OptionPageContent()
      ][currentPageIndex],
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('Ma tension Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),),
            ),
            ListTile(
              title: const Text('Vos programmes'),
              leading: const Icon(Icons.date_range_outlined, color: Colors.black),
              onTap: () {
                openFullscreenProgramme(context);
              },
            ),
            ListTile(
              title: const Text('Vos conseils'),
              leading: const Icon(Icons.comment_bank_sharp, color: Colors.black),
              selected: _selectedIndex == 1,
              onTap: () {
                openFullscreenConseils(context);
              },
            ),
            ListTile(
              title: const Text('Donts effectuer'),
              leading: const Icon(Icons.shopify, color: Colors.black),
              selected: _selectedIndex == 2,
              onTap: () {
                openFullscreenDonts(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void openFullscreenDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Notification', style: TextStyle(fontFamily: "Poppins", fontSize: 26,fontWeight: FontWeight.bold)),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  removeNotification('Nouvelle Notification');
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                TextButton(
                  child: const Text('Fermer', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                  onPressed: () {
                    addNotification('Nouvelle Notification');// Ajout d'une nouvelle notification
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: notifications.map(
                        (notification) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.notifications_sharp),
                        title: Text(notification),
                        subtitle: Text('Notification Details'),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void openFullscreenConseils(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Vos Conseills',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 26),),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton(
                  child: const Text('Fermer', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void openFullscreenProgramme(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Vos Programme',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 26),),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton(
                  child: const Text('Fermer', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void openFullscreenDonts(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Vos Donts',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 26),),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton(
                  child: const Text('Fermer', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void openFullscreenHistorique(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Historique',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 26),),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                TextButton(
                  child: const Text('Fermer', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void addNotification(String notification) {
    setState(() {
      notifications.add(notification);
    });
  }
  void removeNotification(String notification) {
    setState(() {
      notifications.remove(notification);
    });
  }
}
