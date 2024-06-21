import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class DontPageContent extends StatefulWidget {
  const DontPageContent({Key? key});

  @override
  State<DontPageContent> createState() => _DontPageContentState();
}

class _DontPageContentState extends State<DontPageContent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DontPage(),
    );
  }
}

class DontPage extends StatefulWidget {

  @override
  State<DontPage> createState() => _DontPageState();
}

class _DontPageState extends State<DontPage> {
  String selectedConfType = 'sd';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PhoneNumber? _phoneNumber;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: CustomAppBar(),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0,left: 10.0,right:10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 200),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                      child: Text(
                        'Faites un don à la fondation afin de sauver des vies. Un coeur, une vie',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: "Votre Nom d'utilisateur",
                          hintText: "Votre Nom d'utilisateur",
                          helperText: "Veillez entrez votre Nom d'utilisateur",
                          border: const OutlineInputBorder(),
                        ),
                        style: TextStyle(fontFamily: 'Poppins'),
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
                      child: SizedBox(
                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            helperText: "Entrez le numéro de téléphone du donnataire",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'CM',
                          onChanged: (phone) {
                            _phoneNumber = phone;
                          },
                          validator: (value) {
                            if (_phoneNumber == null || _phoneNumber!.number.isEmpty) {
                              return 'Veuillez entrer votre numéro de téléphone';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.shopify),
                          labelText: "Votre somme d'argent",
                          hintText: "Votre somme d'argent",
                          helperText: "Veillez entrez votre somme d'argent",
                          border: const OutlineInputBorder(),
                        ),
                        style: TextStyle(fontFamily: 'Poppins'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer Somme D'argent";
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      height: 100,
                      child: Builder(
                        builder: (context) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(
                                  value: 'sd',
                                  child: Row(
                                    children: [
                                      Text("--Selectionner un moyen de paiement--"),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Om',
                                  child: Row(
                                    children: [
                                      Text("Orange Money"),
                                      SizedBox(width: 10),
                                      Image.asset("assets/image/orange.jpg", width: 70, height: 70),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'mtn',
                                  child: Row(
                                    children: [
                                      Text("Mobile Money"),
                                      SizedBox(width: 10),
                                      Image.asset("assets/image/mtn.jpg", width: 80, height: 80),
                                    ],
                                  ),
                                ),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: selectedConfType,
                              onChanged: (value) {
                                setState(() {
                                  selectedConfType = value as String;
                                });
                              },
                              validator: (value) {
                                if (_phoneNumber == null || _phoneNumber!.number.isEmpty) {
                                  return 'Chosir un mode de paiement';
                                }
                                return null;
                              },
                            ),

                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: "Mini Commentaire(Facultatif)",
                          hintText: "Saisir un commentaire ",
                          border: const OutlineInputBorder(),
                        ),
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Logique lorsque le formulaire est valide
                        }
                      },
                      backgroundColor: Colors.green,
                      tooltip: 'Extended',
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Faire un dont', style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
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
              "assets/image/don.jpg",
              fit: BoxFit.cover,
            ),
            Center(
              child: Text(
                "Don",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
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
