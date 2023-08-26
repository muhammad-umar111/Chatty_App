
import 'package:chatty_box/HomeScreens.dart/forgotPasswordScreen.dart';
import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat.dart/loginDataWithEmail.dart';


class SignInWithEmail extends StatefulWidget {
  const SignInWithEmail({super.key});
  static const pageName='/SignInWithEmail';
  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}


class _SignInWithEmailState extends State<SignInWithEmail> {
  final _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController=TextEditingController();
    _passwordController=TextEditingController();
  }
  @override
  void dispose() {
     _emailController.dispose();
     _passwordController.dispose();
    super.dispose();
  }
  void loginAccount()async{
    Helper.showLoadingDialogue(context,'SignIn...');

    try {
  // ignore: unused_local_variable
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim()
  ).then((value) {
    loginWithEmail(context);
    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('login successfully')));
  });
} on FirebaseAuthException catch (e) {
  Navigator.pop(context);
  Helper.showAlertDialogue(context,'Sign In With Email',e.toString());
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
  }
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.sizeOf(context);
  final height=size.height;
  final width=size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Opacity(
        opacity: 1,
        child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/background.jpg',),fit: BoxFit.cover)
     
      ),
       child: Form(
        key: _loginFormKey,
         child: Column(
         children: [
          const Spacer(flex: 1,),
          const Expanded(flex: 1,child:Center(
            child: Text(
              'LogIn',style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900),),
          ),),
           const Expanded(flex: 1,child:Center(
            child: Text(
              'Let`s go to chat',style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 22,
                fontWeight: FontWeight.w500),),
          ),),
          // Second child completed
           const Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 15,bottom: 1),
                child: Text('Email',style: TextStyle(color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600),),
              )) ),
              
           Expanded(flex: 1,child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 3),
              child: 
              SizedBox(
                width: width,
                height: height,
                child: Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) {
                       if (value!.isEmpty) {
               return 'Please enter an email address.';
               } else if (!validateEmail(value)) {
               return 'Please enter a valid email address.';
               }
               return null; // Return null if the email is valid

                        
                      
                        
                      
                    },
                     decoration: InputDecoration(
                      fillColor: Color.fromARGB(244, 144, 142, 145),
                      
                      filled: true,
                      prefixIcon: const Icon(Icons.email_outlined,color: Color.fromARGB(255, 27, 68, 139),),
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      )
                      ,
                     ),
                  ),
                ),
              ),
             )),
           
           
       // Email
        const Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 15,bottom: 1),
                child: Text('Password',style: TextStyle(color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600),),
              )) ),
              
       Expanded(flex: 1,child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
              child: Container(
                width: width,
                height: height,
                child: Opacity(
                  opacity: 0.7,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                     if (value!.isEmpty) {
               return 'Please enter Password';
               } else if (!validatePassword(value)) {
               return 'Your password contain at least \n"one special char,numb,lower or uppercase"';
               }
               return null; 
                        
                      

                    },
                     decoration: InputDecoration(
                      fillColor: Color.fromARGB(244, 144, 142, 145),
                      
                      filled: true,
                      prefixIcon: const Icon(Icons.lock,color: Color.fromARGB(255, 27, 68, 139),),
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      )
                      ,
                     ),
                  ),
                ),
              ),
            )),
            Expanded(flex: 1,child: Padding(
              padding: const EdgeInsets.only(right: 9,top: 3),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, ForgotPasswordScreen.pageName);
                },
                child: SizedBox(
                  height: height,
                  width: width,
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'FORGOT PASSWORD?',style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),),
                  ),
                ),
              ),
            )),
            Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29,vertical: 8),
                child: InkWell(
                  onTap: () {
                    if (_loginFormKey.currentState!.validate()) {
                     loginAccount();
                   } else {
                     
                   }
                   
                  },
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 8, 111, 190),
                     //image: DecorationImage(image: AssetImage('assets/images/background.jpg',
                    // ),fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(5)),
                      
                      child: const Center(child: Text("Login your account",style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16,fontStyle: FontStyle.italic),)),
                    ),
                  ),
                ),
              )),
             
             
             Spacer(flex: 2,)
         ],
         ),
       ),   
      ),
      
    ));
  }
}