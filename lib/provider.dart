import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_deletion/delete_acc.dart';
import 'constants.dart';
import 'main.dart';

class FirebaseFunctions extends ChangeNotifier {
  deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        log(FirebaseAuth.instance.currentUser!.uid);
        var collection = await FirebaseFirestore.instance
            .collection(Constants.FIREBASECOLLECTIONKEY)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (collection.get(Constants.FIREBASEIMAGEKEY) != "") {
          FirebaseStorage.instance
              .ref()
              .child('images')
              .child(FirebaseAuth.instance.currentUser!.uid)
              .delete()
              .then((value) =>
                  FirebaseAuth.instance.currentUser!.delete().then((value) {
                    scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                    scaffoldMessengerKey.currentState!.showSnackBar(
                        const SnackBar(content: Text("Account deleted")));
                  }));
        }
        FirebaseFirestore.instance
            .collection(Constants.FIREBASECOLLECTIONKEY)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete()
            .then((value) {
          FirebaseAuth.instance.currentUser!.delete().then((value) {
            scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
            formKey.currentState!.reset();
            scaffoldMessengerKey.currentState!
                .showSnackBar(const SnackBar(content: Text("Account deleted")));
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("No user found for that email")));
      } else if (e.code == 'wrong-password') {
        scaffoldMessengerKey.currentState!
            .showSnackBar(const SnackBar(content: Text("Wrong password")));
      } else if (e.code == 'too-many-requests') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("Too many requests try again later")));
      } else if (e.code == 'user-disabled') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("The email has been disabled")));
      }
    }
  }
}
