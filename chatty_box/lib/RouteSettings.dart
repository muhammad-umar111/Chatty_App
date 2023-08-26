import 'package:chatty_box/HomeScreens.dart/forgotPasswordScreen.dart';
import 'package:chatty_box/OtpVerifiedScreen.dart';
import 'package:chatty_box/chat.dart/ChatList.dart';
import 'package:chatty_box/chat.dart/ChatRoomPage.dart';
import 'package:chatty_box/chat.dart/Complete_profile.dart';
import 'package:chatty_box/signIn_email.dart';
import 'package:chatty_box/signupScreen.dart';
import 'package:flutter/material.dart';

import 'SplashScreen.dart';
import 'HomeScreens.dart/LoginScreen.dart';

Route onGenerateRoute(RouteSettings settings){
   final args = settings.arguments as Map<String, dynamic>?;
  if (settings.name== SplashScreen.pageName) {

    return MaterialPageRoute(builder: (context) => const SplashScreen(),);
  } else if(settings.name==SignUpScreen.pageName){
    return MaterialPageRoute(builder: (context) => const SignUpScreen(),);
   }else if(settings.name==CompleteProfile.pageName){
    return MaterialPageRoute(builder: (context) => const CompleteProfile(),);
   }
   else if(settings.name==ChatRoomPage.pageName){
    return MaterialPageRoute(builder: (context) =>  ChatRoomPage(
      username:args!['username'],
      photoUrl:args['photoUrl'],
      chatRoomModel:args['chatRoomModel'] ,
      currentUserId:args['currentUserId'],))
    ;
   }
   else if(settings.name==ForgotPasswordScreen.pageName){
    return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen(),);
   }
   else if(settings.name==OtpVerifiedScreen.pageName){

    return MaterialPageRoute(builder: (context) =>
      OtpVerifiedScreen(verificationId: settings.arguments as String),);
  }
  else if(settings.name==SignInWithEmail.pageName){
    return MaterialPageRoute(builder: (context) => const SignInWithEmail(),);
  }else if(settings.name==LoginScreen.pageName){
   return MaterialPageRoute(builder:  (context) => const LoginScreen(),);
  }
  else{
    return MaterialPageRoute(builder: (context) => const ChatList(),);
  }
}