import 'dart:async';

import 'package:chatty_box/chat.dart/ChatList.dart';
import 'package:chatty_box/chat.dart/Complete_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'HomeScreens.dart/LoginScreen.dart';
String ?username1;
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const pageName='/SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkScreen()async{
  final auth=FirebaseAuth.instance;
  final user=auth.currentUser;
    if (user!=null) {
   final userData=await FirebaseFirestore.instance.collection('User`s').doc(user.uid).get();

  final photoUrl=userData.get('photoUrl');
username1=userData.get('username');
      
       if (photoUrl.isEmpty) {
      Navigator.pushReplacementNamed(context, CompleteProfile.pageName);
       } else {
        Navigator.pushReplacementNamed(context, ChatList.pageName);
         
       }
 
    } else {
      return
      Navigator.pushReplacementNamed(context, LoginScreen.pageName);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () { 
      checkScreen();


    });
  
  }
  @override
  Widget build(BuildContext context) {
   
    final Size size=MediaQuery.of(context).size;
    final height=size.height;
    final width =size.width;
    return Scaffold(
      
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 5,child:
               Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/chat.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
              ),
            ),
             Expanded(flex: 1,child:
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.chat,color: Colors.blue,size: 40,)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:4.0),
                      child: Text('Chatty App',style:
                      TextStyle(
                          color: Color.fromARGB(255, 58, 106, 239)
                          ,fontWeight: FontWeight.w900,
                          fontSize: 35
                        )),
                    ),
                  ),
                ],
              ),
            )),
            Expanded(flex: 1,child:
            SizedBox(
              width: width,
              height: height,
              child: Align(
                alignment: Alignment.center,
                child: Text('"Accept incoming Multiple Sources"',style:
                TextStyle(
                    color: Colors.black
                    ,fontWeight: FontWeight.w900,
                    fontSize: 19
                  )),
              ),
            )),
            Expanded(flex: 1,child:
            SizedBox(
              width: width,
              height: height,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Text('Recommended features for the assignment of orders to trucks and drivers available nearby!',style:
                    TextStyle(
                        color: Colors.black
                        ,fontWeight: FontWeight.w900,
                        fontSize: 19
                      )),
                  ),
                ),
              ),
            )),
            Spacer(flex: 1,)   
            ],
            ),
      ),
          
        
      );
    
  }
}