import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_heart/NewUser/NewUser_page.dart';
import 'package:my_heart/OTP_and_user/OTP_page.dart';
import 'package:my_heart/connexion/Email.dart';

class ConnexionPage extends StatefulWidget {
  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String? verificationId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                    "Veuillez entrer votre\nnuméro de téléphone",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConnexionEmailPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Connexion Par email',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Numéro de téléphone",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      _formKey.currentState?.save();
                      if (_formKey.currentState?.validate() ?? false) {
                        String phoneNumber = _phoneNumberController.text.trim();
                        if (phoneNumber.isNotEmpty) {
                          await signInWithPhone(context, phoneNumber);
                        } else {
                          showError(context, 'Veuillez entrer un numéro de téléphone.');
                        }
                      }
                    },
                    backgroundColor: Colors.red,
                    label: Text(
                      'Soumettre',
                      style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                    ),
                    icon: Icon(Icons.gpp_good_rounded, color: Colors.white),
                  ),
                  SizedBox(height: 10),
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
      ),
    );
  }

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    print("Phone number entered: $phoneNumber");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          // Naviguer vers la page suivante pour entrer le code OTP
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPAuthenticationScreen(verificationId: '',)),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showError(context, e.message ?? 'Message de bug');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          // Naviguer vers la page suivante pour entrer le code OTP
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPAuthenticationScreen(verificationId: verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      showError(context, e.toString());
    }
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
