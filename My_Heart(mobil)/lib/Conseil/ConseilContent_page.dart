import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConseilPageContent extends StatelessWidget {
  const ConseilPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConseilPage(),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.dialogMessage,
    required this.color,
    required this.backgroundIcon,
    this.nextColor,
  });

  final String title;
  final String time;
  final IconData icon;
  final String dialogMessage;
  final Color color;
  final IconData backgroundIcon;
  final Color? nextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nextColor,
      child: Stack(
        children: [
          Container(
            height: 150, // Ajustez la hauteur selon vos besoins
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      backgroundIcon,
                      size: 200, // Ajustez la taille selon vos besoins
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    top: 20.0,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        time,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(icon, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Détail du Conseil'),
                                    content: Text(dialogMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Fermer'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class ConseilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: CustomAppBar(), // dans la class de la appbar
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CurvedListItem(
            title: 'Faire du Yoga plusieurs fois par jour',
            time: 'Conseil #1',
            icon: Icons.self_improvement,
            dialogMessage: 'Détails sur le yoga et la méditation pour les débutants.',
            color: Colors.red,
            backgroundIcon: Icons.self_improvement,
            nextColor: Colors.green,
          ),
          CurvedListItem(
            title: 'Pratiquer une activité physique régulière',
            time: 'Conseil #2',
            icon: FontAwesomeIcons.bicycle,
            dialogMessage: 'Détails sur les sports à pratiquer par jour',
            color: Colors.green,
            backgroundIcon: FontAwesomeIcons.bicycle,
            nextColor: Colors.orange,
          ),
          CurvedListItem(
            title: "Boire beaucoup d'eau par jour",
            time: 'Conseil #3',
            icon: FontAwesomeIcons.glassWater,
            dialogMessage: 'Rester hydraté est essentiel pour la santé.',
            color: Colors.orange,
            backgroundIcon: FontAwesomeIcons.glassWater,
            nextColor: Colors.blue,
          ),
          CurvedListItem(
            title: 'Manger de manière équilibrée',
            time: 'Conseil #4',
            icon: FontAwesomeIcons.utensils,
            dialogMessage: 'Apprenez à cuisiner des plats sains.',
            color: Colors.blue,
            backgroundIcon: FontAwesomeIcons.utensils,
            nextColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

// AppBar customisée pour la page Conseil
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/image/conseil.jpg",
              fit: BoxFit.cover,
            ),
            Center(
              child: Text(
                "Nos Conseils Santé",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
