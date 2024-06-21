import 'package:flutter/material.dart';
import 'package:my_heart/Home/Barchart/Barchart.dart';

import 'onboarding_home/Onboarding.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200), // Diminuer la hauteur
          child: CustomAppBar(),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 200), // Ajuster l'espace pour la CustomAppBar
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.send)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  HomeTabContent(),
                  SendTabContent(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Action pour le bouton '+'
          },
          child: Icon(Icons.add,color: Colors.white),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/image/acceuil.jpg",
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    "Accueil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40, // Ajuster la taille du texte
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTabContent extends StatefulWidget {
  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80),
            Text(
              'Bienvenue sur l\'application \n my Heart' ,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                openFullTension(context);
              },
              icon: Icon(Icons.favorite,color: Colors.white,),
              label: Text('Prendre sa tension',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.red
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class SendTabContent extends StatefulWidget {
  @override
  State<SendTabContent> createState() => _SendTabContentState();
}

class _SendTabContentState extends State<SendTabContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Contenu de l\'onglet Envoyer',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
void openFullTension(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Prise de tension',style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 26),),
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
          ),body: Center(
          child: Onboarding(),
        ),
        ),
      ),
    ),
  );
}