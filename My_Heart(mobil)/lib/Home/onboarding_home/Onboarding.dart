import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_heart/Home/onboarding_home/content.dart';
import '../Barchart/Barchart.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController _controller;
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController diastoleController = TextEditingController();
  final TextEditingController systoleController = TextEditingController();
  final TextEditingController poidsettaille = TextEditingController();

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    pulseController.dispose();
    diastoleController.dispose();
    systoleController.dispose();
    poidsettaille.dispose();
    super.dispose();
  }

  List<String> svgAssets = [
    'assets/image/z (1).svg',
    'assets/image/z (2).svg',
    'assets/image/normal.svg',
    'assets/image/tension.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: svgAssets.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            svgAssets[i],
                            height: 200,
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].title,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 20),
                          if (i == 0) ...[
                            TextField(
                              controller: poidsettaille,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Entrez votre poids',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                            ),
                          ] else if (i == 1) ...[
                            TextField(
                              controller: diastoleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Entrez votre diastole',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                            ),
                          ] else if (i == 2) ...[
                            TextField(
                              controller: systoleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Entrez votre systole',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                            ),
                          ] else if (i == 3) ...[
                            TextField(
                              controller: pulseController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Entrez votre Puls',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    currentIndex == contents.length - 1 ? "Continue" : "Next",
                  ),
                  onPressed: () {
                    print("Poids: ${poidsettaille.text}");
                    print("Diastole: ${diastoleController.text}");
                    print("Systole: ${systoleController.text}");
                    print("Pulse: ${pulseController.text}");

                    if (currentIndex == contents.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BarChartPage(
                            poids: poidsettaille.text,
                            diastole: diastoleController.text,
                            systole: systoleController.text,
                            pulse: pulseController.text,
                          ),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Theme.of(context).primaryColor, // Couleur du texte
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
