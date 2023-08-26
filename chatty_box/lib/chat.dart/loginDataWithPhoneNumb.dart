import 'package:chatty_box/chat.dart/Complete_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

loginWithPhoneNumber(BuildContext context)async{
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if (user!=null) {
    QuerySnapshot<Map<String, dynamic>> result=await FirebaseFirestore.instance.collection('User`s').where('id',isEqualTo: user.uid).get();

      List<DocumentSnapshot> document=result.docs;
      if (document.isEmpty) {
        FirebaseFirestore.instance.collection('User`s').doc(user.uid).set({
               'username':user.displayName,
               'phoneNumber':user.phoneNumber,
               'photoUrl':user.photoURL,
               'id':user.uid
        });
      }
      Navigator.pushReplacementNamed(context, CompleteProfile.pageName);
    } else {
      
    }
  }
