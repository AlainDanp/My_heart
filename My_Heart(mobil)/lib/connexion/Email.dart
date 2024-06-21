import 'package:flutter/material.dart';
import 'package:my_heart/Home/HomeContent_page.dart';
import 'package:my_heart/Menu/Menu_page.dart';
import 'package:my_heart/NewUser/NewUser_page.dart';
import 'package:my_heart/OTP_and_user/connexion_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConnexionEmailPage extends StatefulWidget {
  @override
  State<ConnexionEmailPage> createState() => _ConnexionEmailPageState();
}

class _ConnexionEmailPageState extends State<ConnexionEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connexion',
          style: TextStyle(
            fontFamily: "Poppins",
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/image/logo.png"),
                  height: 250,
                  width: 250,
                ),
                SizedBox(height: 20),
                Text(
                  "Veuillez entrer votre email et votre mot de passe",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConnexionPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Connexion Par Numéro de téléphone',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Email',
                      hintText: 'Entrez votre Email',
                      helperText: 'Entrez votre Email',
                      border: const OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                      helperText: 'Entrez votre mot de passe',
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  onPressed: () async {
                    String email = emailController.text;
                    String password = passwordController.text;
                    print('Email: $email, Password: $password'); // Ligne de débogage
                    try {
                      await signInWithEmailAndPassword(email, password, context);
                    } catch (e) {
                      showAlertDialog(context, 'Erreur', e.toString());
                    }
                  },

                  backgroundColor: Colors.red,
                  label: Text(
                    'Soumettre',
                    style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                  ),
                  icon: Icon(Icons.gpp_good_rounded, color: Colors.white),
                ),

                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewUser(),
                      ),
                    );
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> userExistsInFirestore(String email, String password) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Patient')
      .where('Email', isEqualTo: email)
      .where('Mot_de_passe', isEqualTo: password)
      .get();
  return querySnapshot.docs.isNotEmpty;
}
Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
  try {
    bool userExists = await userExistsInFirestore(email, password);
    if (userExists) {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      showAlertDialog(context, 'Erreur', 'Votre compte n\'existe pas dans la base de données ou le mot de passe est incorrect.');
    }
  } catch (e) {
    if (e is FirebaseAuthException) {
      print('FirebaseAuthException code: ${e.code}'); // Ligne de débogage
      switch (e.code) {
        case 'user-not-found':
          showAlertDialog(context, 'Erreur', 'Aucun utilisateur trouvé avec cet email.');
          print("PAS DE USER");

        case 'wrong-password':
          showAlertDialog(context, 'Erreur', 'Mot de passe incorrect.');
          break;
        case 'invalid-email':
          showAlertDialog(context, 'Erreur', 'L\'adresse email n\'est pas valide.');
          break;
        case 'invalid-credential':
          showAlertDialog(context, 'Erreur', 'Les informations d\'identification sont invalides.');
          break;
        default:
          showAlertDialog(context, 'Erreur', 'Entrer votre Mot de passe et  Votre Email \n Veuillez Entrer et Réessayer.');
      }
    } else {
      print('Non-FirebaseAuthException error: ${e.toString()}'); // Ligne de débogage
      showAlertDialog(context, 'Erreur', 'Une erreur sur votre mot de passe ou votre Email.');
    }
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
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
