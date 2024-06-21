import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:my_heart/OTP_and_user/connexion_page.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String _selectedGender = '';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');
  String _completePhoneNumber = '';

  Future<void> _addUserToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('Patient').add({
        'Nom': _nameController.text,
        'Numéro': _completePhoneNumber,
        'Mot_de_passe': _passwordController.text,
        'Date_de_naissance': _selectedDate?.toIso8601String(),
        'Email': _emailController.text,
        'Genre': _selectedGender,
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User created with email and password: ${userCredential.user!.uid}');
    } catch (e) {
      print('Error creating user with email and password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Créer un Profil",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender =
                            _selectedGender == 'man' ? '' : 'man';
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_selectedGender == 'man')
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.5),
                                ),
                              ),
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                'assets/image/man.png',
                              ),
                            ),
                            if (_selectedGender == 'man')
                              Positioned(
                                bottom: 7,
                                right: 20,
                                child: Icon(Icons.check, color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender =
                            _selectedGender == 'woman' ? '' : 'woman';
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_selectedGender == 'woman')
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.5),
                                ),
                              ),
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                'assets/image/woman.png',
                              ),
                            ),
                            if (_selectedGender == 'woman')
                              Positioned(
                                bottom: 7,
                                right: 20,
                                child: Icon(Icons.check, color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Nom',
                      hintText: 'Entrez votre Nom',
                      helperText: 'Entrez votre Nom',
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
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
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre Mot de passe',
                      helperText: 'Entrez votre Mot de passe',
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: 400,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          _completePhoneNumber = number.phoneNumber ?? '';
                        });
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: _phoneNumberController,
                      formatInput: true,
                      maxLength: 15, // Maximum length for phone number input
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      hintText: 'Date de naissance',
                      labelText: 'Date de naissance',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (DateTime? date) {
                      return null;
                    },
                    onDateSelected: (DateTime date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  onPressed: () async {
                    await _createUserWithEmailAndPassword();
                    await _addUserToFirestore();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ConnexionPage()
                    ),
                    );
                  },
                  backgroundColor: Colors.green,
                  tooltip: 'Enregistrer',
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Enregistrer',
                    style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
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