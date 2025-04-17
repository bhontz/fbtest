import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String about;
  final String email;
  final String userName;

  AppUser({required this.about, required this.email, required this.userName});

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AppUser(
      about: data?['about'],
      email: data?['email'],
      userName: data?['userName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"about": about, "email": email, "userName": userName};
  }
}
