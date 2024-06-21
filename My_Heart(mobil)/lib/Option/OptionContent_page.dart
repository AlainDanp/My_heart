import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:my_heart/Option/option_component/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_heart/connexion/Email.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';


class OptionPageContent extends StatefulWidget {
  const OptionPageContent({Key? key}) : super(key: key);

  @override
  State<OptionPageContent> createState() => _OptionPageContentState();
}

class _OptionPageContentState extends State<OptionPageContent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: Text(
            "Options d'utilisateur",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
          ),
          centerTitle: true,
          backgroundColor: Colors.red.withOpacity(0.2),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              SimpleUserCard(
                userName: "Nom de l'utilisateur",

              ),
              SettingsGroup(
                settingsGroupTitle: "Profil",
                items: [
                  SettingsItem(
                    onTap: () {
                      openFullscreenUSER(context);
                    },
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(),
                    title:
                    'Compte Utilisateur',
                    subtitle:
                    "Modifier votre Compte",
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {
                      openFullscreenPartage(context);
                    },
                    icons: Icons.share,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Partage',
                    subtitle: "Partager votre application avec vos contacts et amis",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.notifications,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.orange,
                    ),
                    title: 'Suivi du médecin',
                    subtitle: "Automatique",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),


                ],
              ),

              SettingsGroup(
                settingsGroupTitle: "Autre",
                items: [
                  SettingsItem(
                    onTap: () {openFullscreenDoc(context);},
                    icons: CupertinoIcons.phone_fill,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.green,
                    ),
                    title: 'Docteur',
                    subtitle: "Contacter un médecin pour vous suivre",
                  ),
                  SettingsItem(
                    onTap: () {
                      openFullscreeEmai(context);
                    },
                    icons: Icons.language,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    title: "Ajout d'information",
                    subtitle: "Associer votre numéro de compte avec une Email et ajouter des information",
                  ),
                  SettingsItem(
                    onTap: () {
                      openFullscreenContact(context);
                    },
                    icons: Icons.group,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.grey,
                    ),
                    title: 'Contacter Nous',
                    subtitle: "Envoyer nous une demande",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Compte",
                items: [
                  SettingsItem(
                    onTap: () { },
                    icons: CupertinoIcons.repeat,
                    title: "A propos de nous",
                  ),
                  SettingsItem(
                    onTap: () {
                      _showConfirmationDialog(
                      context,
                      title: "Déconnexion",
                      message: "Voulez-vous vraiment vous déconnecter?",
                    );
                      },
                    icons: Icons.exit_to_app_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.red,
                      withBackground: true,
                      backgroundColor: Colors.white,
                    ),
                    title: "Déconnexion",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SettingsItem(
                    onTap: () {
                      _showConfirmationDialog2(
                        context,
                        title: "Suppression de compte",
                        message: "Voulez-vous vraiment supprimer votre compte?",
                      );
                    },
                    icons: CupertinoIcons.delete_solid,
                    iconStyle: IconStyle(
                      iconsColor: Colors.red,
                      withBackground: true,
                      backgroundColor: Colors.white,
                    ),
                    title: "Supprimer votre compte",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modifier le compte utilisiateur
  void openFullscreenUSER(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        // Récupérer les données de l'utilisateur connecté
        User? user = FirebaseAuth.instance.currentUser;

        // Vérifier si l'utilisateur est connecté
        if (user != null) {
          // Pré-remplir les champs avec les données de l'utilisateur
          _nameController.text = user.displayName ?? '';
          _emailController.text = user.email ?? '';
          _phoneNumberController.text = user.phoneNumber ?? '';
          String userId = user.uid;
          DocumentReference userDocRef = FirebaseFirestore.instance.collection('Patient').doc(userId);
          // Imprimer l'ID du document dans la console
          print('ID  de l\'utilisateur connecté: ${userDocRef.id}');

          userDocRef.get().then((docSnapshot) {
            if (docSnapshot.exists) {
              print('ID du document Firestore de l\'utilisateur connecté: ${docSnapshot.id}');
            } else {
              print('Aucun document Firestore trouvé pour cet utilisateur');
            }
          }).catchError((error) {
            print('Erreur lors de la récupération du document Firestore: $error');
          });
        }

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Compte Utilisateur',
                  style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 12),
                ),
                centerTitle: false,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  TextButton(
                    child: const Text('Annuler', style: TextStyle(fontFamily: "Poppins", color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Nom',
                                hintText: 'Entrez votre Nom',
                                helperText: 'Modifier votre Nom',
                                border: const OutlineInputBorder(),
                              ),
                              style: TextStyle(fontFamily: "Poppins"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre nom';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                labelText: 'Email',
                                hintText: 'Entrez votre Email',
                                helperText: 'Modifier votre Email',
                                border: const OutlineInputBorder(),
                              ),
                              style: TextStyle(fontFamily: "Poppins"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: "Numéro de téléphone",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre numéro de téléphone';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          FloatingActionButton.extended(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Récupérer les données saisies par l'utilisateur
                                String nom = _nameController.text;
                                String email = _emailController.text;
                                String numeroTelephone = _phoneNumberController.text;

                                try {
                                  print('ID du document Firestore de l\'utilisateur connecté: ${user!.uid}');
                                  // Mettre à jour les données dans Firestore
                                  print(await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Patient').get());
                                  await FirebaseFirestore.instance.collection('Patient').doc().update({
                                    'Nom': nom,
                                    'Email': email,
                                    'Numéro': numeroTelephone,
                                  });

                                  // Afficher un message de succès à l'utilisateur
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Données mises à jour avec succès'),
                                    backgroundColor: Colors.green,
                                  ));

                                  // Fermer la boîte de dialogue
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  // Afficher un message d'erreur à l'utilisateur
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Erreur lors de la mise à jour des données: $e'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              }
                            },
                            backgroundColor: Colors.green,
                            tooltip: 'Extended',
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Modifier', style: TextStyle(color: Colors.white, fontFamily: "Poppins")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void printPatientDocumentIds() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Patient').get();
      querySnapshot.docs.forEach((doc) {
        print('ID du document: ${doc.id}');
      });
    } catch (e) {
      print('Erreur lors de la récupération des documents: $e');
    }
  }
  void getDocumentId(String userId) async {
    try {
      // Recherchez le document dans la collection "Patient" où le champ "UserId" correspond à l'ID de l'utilisateur connecté
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Patient')
          .where('UserId', isEqualTo: userId)
          .get();

      // Si des documents sont trouvés
      if (querySnapshot.docs.isNotEmpty) {
        // Récupérez l'ID du premier document trouvé
        String documentId = querySnapshot.docs[0].id;
        print('ID du document dans la collection Patient: $documentId');
      } else {
        print('Aucun document trouvé dans la collection Patient pour cet utilisateur.');
      }
    } catch (e) {
      print('Erreur lors de la recherche du document: $e');
    }
  }



}
//pour le bouton deconnexion
void _showConfirmationDialog(BuildContext context, {required String title, required String message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
            },
            child: Text("Non"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
            ),

          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Ferme le dialogue
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ConnexionEmailPage(),
              ),
              );
            },
            child: Text("Oui"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red,
            ),
          ),
        ],
      );
    },
  );
}

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConnexionEmailPage(),
      ),
    );
  } catch (e) {
    showError(context, 'Erreur lors de la déconnexion: $e');
  }
}
void showError(BuildContext context, String? errorMessage) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Erreur'),
        content: Text(errorMessage ?? 'Une erreur est survenue.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

// pour le bouton supprimer le compte
void _showConfirmationDialog2(BuildContext context, {required String title, required String message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
            },
            child: Text("Non"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
              // Ajouter ici l'action à réaliser si l'utilisateur clique sur "Oui"
            },
            child: Text("Oui"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red,
            ),
          ),
        ],
      );
    },
  );
}
//Partage de l'application
void openFullscreenPartage(BuildContext context) {

  final String appLink = "https://example.com/download"; // Remplacez par le lien de votre application

  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Partager l'application", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 18),),
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
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Scannez le QR code ou copiez le lien pour partager l\'application',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Image(
                        image: AssetImage("assets/image/Qrcode.png"),
                        width: 200,
                        height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        FlutterClipboard.copy(appLink).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lien copié dans le presse-papiers')),
                          );
                        });
                      },
                      icon: Icon(Icons.copy, color: Colors.white),
                      label: Text('Copier le lien', style: TextStyle(fontFamily: "Poppins", color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ),
                  Text(
                    appLink,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14, color: Colors.white,backgroundColor: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}



//Numéro des médecin
void openFullscreenDoc(BuildContext context) {

  List<String> notifications = [
    'Docteur Nana\n626615155',
    'Docteur Nana \n626615155',
    'Docteur Nana \n626615155',
    'Docteur Nana \n626615155',
  ];
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Contact des médecins",style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 18),),
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
          ),     body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: notifications.map(
                    (notification) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.person_3),
                    title: Text(notification),
                    subtitle: Text('Docteur Spécialiste'),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
        ),
      ),
    ),
  );
}
//pour l'email
void openFullscreeEmai(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Associer votre compte avec un email et ajoutes des informations",
              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 14),
            ),
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
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email',
                            hintText: 'Entrez votre email',
                            helperText: 'Ajouter une email',
                            border: const OutlineInputBorder(),
                          ),
                          style: TextStyle(fontFamily: "Poppins"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Mot de passe',
                            hintText: 'Entrez votre mot de passe',
                            helperText: 'Ajouter votre mot de passe',
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          style: TextStyle(fontFamily: "Poppins"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Profession',
                            hintText: 'Entrez votre Proffession',
                            helperText: 'Ajouter une email',
                            border: const OutlineInputBorder(),
                          ),
                          style: TextStyle(fontFamily: "Poppins"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre Proffession';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton.extended(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Logique lorsque le formulaire est valide
                          }
                        },
                        backgroundColor: Colors.green,
                        tooltip: 'Ajouter',
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Ajouter',
                          style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
void openFullscreenContact(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Nos contacts",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Fermer',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Pour plus d'informations, vous pouvez consulter les liens ci-dessous :",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Ouvre le lien pour les développeurs de l'application
                        _launchURL('https://api.flutter.dev/flutter/material/AppBar-class.html');
                      },
                      child: const Text(
                        "2si-inc",
                        style: TextStyle(fontFamily: "Poppins",color: Colors.white,fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Le premier lien est pour les développeurs de l'application et le deuxième est pour la fondation Coeur et Vie.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Ouvre le lien pour la fondation
                        _launchURL('https://flutter.dev');
                      },
                      child: const Text(
                        "fondation Coeur et vie",
                        style: TextStyle(fontFamily: "Poppins",color: Colors.white,fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


