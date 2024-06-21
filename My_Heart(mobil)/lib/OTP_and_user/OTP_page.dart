import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_heart/Menu/Menu_page.dart';

class OTPAuthenticationScreen extends StatelessWidget {
  final String verificationId;

  OTPAuthenticationScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Authentification',
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
                  image: AssetImage('assets/image/logo.png'),
                  height: 250,
                  width: 250,
                ),
                SizedBox(height: 20),
                Text(
                  "Veuillez entrer votre \ncode d'authentification",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                OtpTextField(
                  numberOfFields: 6, // Nombre de champs de texte pour le code OTP
                  borderColor: Colors.red, // Couleur de bordure des champs
                  showFieldAsBox: true, // Afficher les champs comme des boîtes
                  onSubmit: (String otp) async {
                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: otp,
                      );

                      await FirebaseAuth.instance.signInWithCredential(credential);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } catch (e) {
                      showError(context, 'Code OTP invalide.');
                    }
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Implémenter la logique pour renvoyer le code OTP
                    print("Renvoyer le code cliqué");
                  },
                  child: Text(
                    "Renvoyer le code",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
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

  void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(errorMessage),
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
}
