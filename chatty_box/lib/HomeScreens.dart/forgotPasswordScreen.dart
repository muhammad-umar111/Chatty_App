import 'package:chatty_box/Utils.dart';
import 'package:chatty_box/signIn_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../validations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const pageName='/ForgotPasswordScreen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _recoverFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _emailController=TextEditingController();
  }
  @override
  void dispose() {
 _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.sizeOf(context);
    final width=size.width;
    final height=size.height;
    return Scaffold(
      body: Opacity(
          opacity: 1,
          child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background.jpg',),fit: BoxFit.cover)
       
        ),
         child: Form(
          key: _recoverFormKey,
           child: Column(
           children: [
            const Spacer(flex: 1,),
            Expanded(flex: 1,child:Center(
              child: Text(
                'Reset your Password',style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontStyle: FontStyle.italic,

                  fontWeight: FontWeight.w900),),
            ),),
            const Expanded(flex: 1,child:Center(
              child: Text(
                'Receive an E-mail to \n reset your password',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900),),
            ),),
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
                Expanded(flex: 1,child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29,vertical: 23),
                  child: InkWell(
                    onTap: () async{
                      if (_recoverFormKey.currentState!.validate()) {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text
                          ('A link is send to your email to reset password',
                          style: TextStyle(color: Colors.white,fontSize: 15),)));
                          Navigator.pushReplacementNamed(context, SignInWithEmail.pageName).onError((error, stackTrace) {
                            Utils().showMessage(message: error.toString());
                          });
                        });
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
                        
                        child: const Center(child: Text("Reset your Password",style: TextStyle(
                          color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16,fontStyle: FontStyle.italic),)),
                      ),
                    ),
                  ),
                )),
                Spacer(flex: 2,)
            ])
            )
            )
            ),
    );
  }
}