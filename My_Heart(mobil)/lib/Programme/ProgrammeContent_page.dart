import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProgrammePageContent extends StatelessWidget {
  const ProgrammePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProgrammePage(),
    );
  }
}

class CurvedListItem extends StatefulWidget {
  const CurvedListItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.dialogMessage,
    required this.color,
    required this.backgroundIcon,
    required this.toggleKey,
    this.subscribeButtonColor = Colors.blue,
    this.shareButtonColor = Colors.grey,
    this.nextColor,
  });

  final String title;
  final String time;
  final IconData icon;
  final String dialogMessage;
  final Color color;
  final IconData backgroundIcon;
  final Color subscribeButtonColor;
  final Color shareButtonColor;
  final Color? nextColor;
  final String toggleKey;

  @override
  _CurvedListItemState createState() => _CurvedListItemState();
}

class _CurvedListItemState extends State<CurvedListItem> {
  late bool _isToggled = false;
  late bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _loadToggleState();
  }

  Future<void> _loadToggleState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isToggled = prefs.getBool(widget.toggleKey) ?? false;
    });
  }

  Future<void> _saveToggleState(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.toggleKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.nextColor,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
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
                      widget.backgroundIcon,
                      size: 200,
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
                        widget.time,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(widget.icon, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Détail du Conseil'),
                                    content: Text(widget.dialogMessage),
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
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.favorite, color: _isToggled ? Colors.red : Colors.white),
                            onPressed: () async {
                              final newValue = !_isToggled;
                              await _saveToggleState(newValue);
                              setState(() {
                                _isToggled = newValue;
                              });
                            },  label: Text(
                            _isToggled ? 'Abonné' : 'Désabonné',
                            style: TextStyle(color: _isToggled ? Colors.red : Colors.blue, fontSize: 16),
                          ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Logique pour partager
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Programme partagé')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              elevation: 10,
                              shadowColor: Colors.black,
                            ),
                            icon: Icon(Icons.share),
                            label: Text('Partager'),
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



class ProgrammePage extends StatefulWidget {
  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: CustomAppBar(),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            child: TabBar(
              tabs: [
                Tab(
                    icon: Icon(Icons.home,color: Colors.red,),
                    text: 'Liste des Programmes',),
                Tab(
                  icon: Icon(Icons.send,color: Colors.red,),
                  text: 'Programme Abonnée'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ProgrammeList(),
                ProgrammeAbonnee(),
              ],
            ),
          ),
        ],
      ),
        ),
    );
  }
}

class ProgrammeAbonnee extends StatefulWidget{
  @override
  State<ProgrammeAbonnee> createState() => _ProgrammeAbonneState();
}
class _ProgrammeAbonneState extends State<ProgrammeAbonnee>{
  @override
  Widget build(BuildContext context){
    return Center(

    );
  }
}

class ProgrammeList extends StatefulWidget{
  @override
  State<ProgrammeList> createState() => _ProgrammeListState();
}
class _ProgrammeListState extends State<ProgrammeList>{
  @override
  Widget build(BuildContext context) {
    return Center(
    child: ListView(
      padding: const EdgeInsets.only(bottom: 20),
      scrollDirection: Axis.vertical,
      children: <Widget>[
        CurvedListItem(
          title: 'Durée: 10 jours',
          time: 'PROGRAMME: Semaine sans Sel',
          icon: FontAwesomeIcons.utensils,
          dialogMessage: 'Détails sur le yoga et la méditation pour les débutants.',
          color: Colors.red,
          backgroundIcon: FontAwesomeIcons.utensils,
          subscribeButtonColor: Colors.green,
          shareButtonColor: Colors.blue,
          nextColor: Colors.green,
          toggleKey: 'program_1',
        ),
        CurvedListItem(
          title: 'Durée: 10 jours',
          time: 'PROGRAMME: Marche Sportive',
          icon: Icons.fitness_center,
          dialogMessage: 'Détails sur les sports à pratiquer par jour',
          color: Colors.green,
          backgroundIcon: Icons.fitness_center,
          subscribeButtonColor: Colors.blue,
          shareButtonColor: Colors.red,
          nextColor: Colors.orange,
          toggleKey: 'program_2',
        ),
        CurvedListItem(
          title: 'Durée: 10 jours',
          time: 'PROGRAMME: SPORT pour tous',
          icon: Icons.fitness_center,
          dialogMessage: 'Rester hydraté est essentiel pour la santé.',
          color: Colors.orange,
          backgroundIcon: Icons.fitness_center,
          subscribeButtonColor: Colors.red,
          shareButtonColor: Colors.green,
          nextColor: Colors.blue,
          toggleKey: 'program_3',
        ),
        CurvedListItem(
          title: 'Durée: 10 jours',
          time: 'PROGRAMME: Semaine sans Sucre',
          icon: FontAwesomeIcons.utensils,
          dialogMessage: 'Apprenez à cuisiner des plats sains.',
          color: Colors.blue,
          backgroundIcon: FontAwesomeIcons.utensils,
          subscribeButtonColor: Colors.orange,
          shareButtonColor: Colors.purple,
          nextColor: Colors.white,
          toggleKey: 'program_1',
        ),
      ],
    ),
    );
  }

}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/image/programme.jpg",
              fit: BoxFit.cover,
            ),
            Center(
              child: Text(
                "Programme",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
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

