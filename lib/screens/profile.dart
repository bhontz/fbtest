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
  final double coverHeight = 200;
  final double profileHeight = 150;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  String defaultUserName = "Click To Add Your UserName";
  bool isEditingUserName = false;
  String defaultAbout = "Click to say some more about you.";
  bool isEditingAbout = false;
  AppUser? appUser;
  Uint8List? pickedImage;
  String? pickedWebImage;
  final String? emailFromAuth = FirebaseAuth.instance.currentUser!.email;
  User? user =
      FirebaseAuth.instance.currentUser; // from AUTH, part of the database key

  @override
  void initState() {
    super.initState();
    getProfilePicture(); // get a prexisting profile picture from storage
    getTextFields();
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("${emailFromAuth}_profilepic.jpg");

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      debugPrint('Profile picture not found. $e');
    }
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

  Future<void> onProfileImageTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );
    if (image == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("${emailFromAuth}_profilepic.jpg");
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);
    setState(() => pickedImage = imageBytes); // WHAT IT WAS BEFORE WEB ADD
    // if (kIsWeb) {
    //   setState(() => pickedWebImage = image.path);
    // } else {
    //   setState(() => pickedImage = imageBytes);
    // }
  }

  Future<AppUser?> getAppUser() async {
    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(emailFromAuth)
        .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
        );
    final docSnap = await ref.get();
    return docSnap.data();
  }

  Future<void> getTextFields() async {
    appUser = await getAppUser();
    setState(() {
      defaultUserName =
          appUser != null ? appUser!.userName : "Click To Add Your UserName";
      defaultAbout =
          appUser != null
              ? appUser!.about
              : "Click to say some more about you.";
    });
  }

  void changeAndUpdateUserName(String txt) {
    setState(() {
      defaultUserName = txt;
      isEditingUserName = false;
      appUser!.userName = defaultUserName;
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(emailFromAuth)
        .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
        )
        .set(appUser!)
        .onError((e, _) => debugPrint("error on Users.userName write: $e"));
  }

  void changeAndUpdateAbout(String txt) {
    setState(() {
      defaultAbout = txt;
      isEditingAbout = false;
      appUser!.about = defaultAbout;
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(emailFromAuth)
        .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser appUser, _) => appUser.toFirestore(),
        )
        .set(appUser!)
        .onError((e, _) => debugPrint("error on Users.about write: $e"));
  }

  Widget editUserNameField() {
    if (isEditingUserName) {
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            changeAndUpdateUserName(newValue);
          },
          autofocus: true,
          controller: userNameController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            isEditingUserName = true;
          });
        },
        child: Center(
          child: Text(
            defaultUserName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget editAboutField() {
    if (isEditingAbout) {
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            changeAndUpdateAbout(newValue);
          },
          autofocus: true,
          controller: aboutController,
          style: TextStyle(color: Colors.black, fontSize: 16.0, height: 1.4),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            isEditingAbout = true;
          });
        },
        child: Center(
          child: Text(
            defaultAbout,
            style: TextStyle(color: Colors.black, fontSize: 16.0, height: 1.4),
          ),
        ),
      );
    }
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
              child: CircleAvatar(
                radius: coverHeight / 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: coverHeight / 10,
                ),
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

  // Widget avatarForTarget() {
  //   if (kIsWeb) {
  //     debugPrint("got into avatorForTarget - web path");
  //     return CircleAvatar(
  //       radius: profileHeight / 2,
  //       backgroundColor: Colors.white,
  //       backgroundImage: NetworkImage(
  //         'https://res.cloudinary.com/dpeqsj31d/image/upload/v1707263739/avatar_2_2.png',
  //       ),
  //       // backgroundImage:
  //       //     pickedWebImage != null
  //       //         ? NetworkImage(
  //       //           'https://res.cloudinary.com/dpeqsj31d/image/upload/v1707263739/avatar_2_2.png',
  //       //         )
  //       //         : null,
  //     );
  //   } else {
  //     return CircleAvatar(
  //       radius: profileHeight / 2,
  //       backgroundColor: Colors.white,
  //       backgroundImage:
  //           pickedImage != null
  //               ? Image.memory(pickedImage!, fit: BoxFit.cover).image
  //               : null,
  //     );
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          buildPageTop(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                editUserNameField(),
                const SizedBox(height: 10),
                Text(
                  'About',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                editAboutField(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
