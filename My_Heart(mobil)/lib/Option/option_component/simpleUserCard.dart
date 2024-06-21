import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleUserCard extends StatefulWidget {
  final String userName;
  final double? imageRadius;
  final Widget? userMoreInfo;
  final TextStyle? textStyle;
  final Icon? icon;

  SimpleUserCard({
    required this.userName,
    this.imageRadius = 10,
    this.userMoreInfo,
    this.textStyle,
    this.icon,
  });

  @override
  _SimpleUserCardState createState() => _SimpleUserCardState();
}

class _SimpleUserCardState extends State<SimpleUserCard> {
  late File _imageFile =
  File(''); // Initialisation avec une chaîne vide
  final ImagePicker _picker = ImagePicker();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    _prefs = await SharedPreferences.getInstance();
    final imagePath = _prefs.getString('imagePath');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _imageFile = File(imagePath!);
      });
    }
  }

  Future<void> _pickImageGallery() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    _prefs.setString('imagePath', pickedFile.path);
  }

  Future<void> _pickImageCamera() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    _prefs.setString('imagePath', pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    double mediaQueryWidth = MediaQuery.of(context).size.width;

    return Container(
      width: mediaQueryWidth,
      height: mediaQueryHeight / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImageGallery,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(widget.imageRadius!),
                  child: _imageFile != null &&
                      _imageFile.existsSync()
                      ? Image.file(
                    _imageFile,
                    fit: BoxFit.cover,
                    height: mediaQueryHeight / 5,
                    width: mediaQueryWidth / 2.6,
                  )
                      : Image.asset(
                    "assets/image/logo.png",
                    fit: BoxFit.cover,
                    height: mediaQueryHeight / 5,
                    width: mediaQueryWidth / 2.6,
                  ),
                ),
                if (widget.icon != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: widget.icon!,
                  ),

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              widget.userName,
              style: widget.textStyle ??
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          if (widget.userMoreInfo != null) widget.userMoreInfo!,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: (){
                  _pickImageGallery();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black,
                ),
                icon: Icon(Icons.camera_alt),
                label: Text("Galerie",style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
              ),
              ElevatedButton.icon(
                onPressed: (){
                  _pickImageCamera();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black,
                ),
                icon: Icon(Icons.camera),
                label: Text("Camera",style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ],
      ),
    );
  }
}
