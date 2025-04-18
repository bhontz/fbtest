import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';
import 'dart:developer'
    as log_dev; // provide a print() debug function to the debug console
import 'package:intl/intl.dart';
import 'dart:math';

AppUser? thisUser;

class FirestoreDatabase {
  final String bookId;

  FirestoreDatabase({required this.bookId});

  User? user =
      FirebaseAuth.instance.currentUser; // from AUTH, part of the database key

  CollectionReference fbCommentsForBookId(bookId) {
    return FirebaseFirestore.instance
        .collection('Comments')
        .doc(bookId)
        .collection('Comments');
  }

  Future<void> getAppUser() {
    var userCollection = FirebaseFirestore.instance.collection('Users');
    var docRef = userCollection.doc(user?.email);
    return docRef.get();
  }

  String createMessageId() {
    var rng = Random();
    var formatter = DateFormat('yyyyMdHms');
    String formatted = formatter.format(DateTime.now());
    return ('$formatted${rng.nextInt(999).toString().padLeft(4, '0')}');
  }

  Future<void> addComment(String commentText) {
    String messageId = createMessageId();
    var commentsCollection = fbCommentsForBookId(bookId);
    var docRef = commentsCollection.doc(messageId);
    return docRef.set({
      'messageId': messageId,
      'userId': user?.email,
      'comment': commentText,
      'timestamp': DateTime.now(),
    });
  }

  void deleteComment(String messageId) async {
    var commentsCollection = fbCommentsForBookId(bookId);
    var docRef = commentsCollection.doc(messageId);
    try {
      await docRef.delete();
    } catch (e) {
      log_dev.log('$e');
    }
  }

  Stream<QuerySnapshot> getComments() {
    var commentsCollection = fbCommentsForBookId(bookId);
    final commentStream = commentsCollection.snapshots();

    return commentStream;
  }
}

class FirestoreStorage {
  Future<String?> getURL(String path) async {
    try {
      String imageURL =
          await FirebaseStorage.instance.ref().child(path).getDownloadURL();
      return imageURL;
    } catch (e) {
      log_dev.log("Error reading from FirebaseStorage. $e");
      return null;
    }
  }
}
