import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
// import 'dart:io';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController userNameController = TextEditingController();
  final double coverHeight = 200;
  final double profileHeight = 150;
  final String defaultUserName = "Click To Add Your UserName";
  Uint8List? pickedImage;

  User? user =
      FirebaseAuth.instance.currentUser; // from AUTH, part of the database key

  @override
  void initState() {
    super.initState();
    getProfilePicture(); // get a prexisting profile picture from storage
    getTextFields();
  }

  Future<AppUser?> getAppUser() async {
    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.email)
        .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
        );
    final docSnap = await ref.get();
    final appUser = docSnap.data();

    return appUser;
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("testprofileimage.jpg");

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      debugPrint('Profile picture not found. $e');
    }
  }

  Future<void> getTextFields() async {
    final test = await getAppUser();
    debugPrint(test!.userName);
  }

  Future<void> onProfileImageTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (image == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("testprofileimage.jpg");
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);
    setState(
      () => pickedImage = imageBytes,
    ); // you would use the users email address here for this image
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background001.png', // will eventually make this selectable to toggle through backgrounds
            width: double.infinity,
            height: coverHeight,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 15,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: coverHeight / 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // backgroundImage: NetworkImage(  // this needs to be added to support the web
  //   'https://res.cloudinary.com/dpeqsj31d/image/upload/v1707263739/avatar_2_2.png',
  // ),

  Widget buildProfileImage() {
    return GestureDetector(
      onTap: onProfileImageTapped,
      child: CircleAvatar(
        radius: profileHeight / 2 + 5,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: Colors.white,
          backgroundImage:
              pickedImage != null
                  ? Image.memory(pickedImage!, fit: BoxFit.cover).image
                  : null,
        ),
      ),
    );
  }

  Widget buildPageTop() {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildPageContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              debugPrint("tapping that.");
            },
            child: Center(
              child: Text(
                'User Name Here',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'About',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }

  // Future getImage(bool isCamera) async {
  //   XFile? image;

  //   if (isCamera) {
  //     image = await ipick.pickImage(
  //       source: ImageSource.camera,
  //       maxHeight: 500,
  //       maxWidth: 500,
  //     );
  //   } else {
  //     image = await ipick.pickImage(
  //       source: ImageSource.gallery,
  //       maxHeight: 500,
  //       maxWidth: 500,
  //     );
  //   }

  //   setState(() {
  //     _image = image;
  //   });
  // }

  // Widget displayImage(XFile? pickedFile) {
  //   if (pickedFile != null) {
  //     return kIsWeb
  //         ? Image.network(pickedFile.path)
  //         : Image.file(File(pickedFile.path));
  //   } else {
  //     return Text("No image selection.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          buildPageTop(),
          buildPageContent(),
          // FloatingActionButton(
          //   child: Text('Camera'),
          //   onPressed: () {
          //     getImage(true);
          //   },
          // ),
          // SizedBox(height: 10.0),
          // FloatingActionButton(
          //   child: Text('Gallery'),
          //   onPressed: () {
          //     getImage(false);
          //   },
          // ),
          // displayImage(_image),
        ],
      ),
    );
  }
}
