import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/signIn_email.dart';
import 'package:chatty_box/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const pageName='/SignUpScreen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController=TextEditingController();
    _passwordController=TextEditingController();
    _nameController=TextEditingController();

  }
  @override
  void dispose() {
     _emailController.dispose();
     _passwordController.dispose();
    _nameController=TextEditingController();

    super.dispose();
  }
  void createAccount()async{
      Helper.showLoadingDialogue(context,'SignUP....');

   try {
  
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    
  )
  .then((value) {
    Navigator.pushReplacementNamed(context,SignInWithEmail.pageName);
  });
} on FirebaseAuthException catch (e) {
  Navigator.pop(context);

  Helper.showAlertDialogue(context,'SignUp', e.toString());

  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  Navigator.pop(context);

  Helper.showAlertDialogue(context,'SignUp', e.toString());
  
  print(e);
}
  }
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.sizeOf(context);
  final height=size.height;
  final width=size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        
        child: Opacity(
          opacity: 1,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.jpg',),fit: BoxFit.cover)
            ,color: Colors.white
            ),child: Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  const Expanded(flex: 1,child:Center(
                child: Text(
                  'Create an free Account',style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800),),
              ),),
              const Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 13,bottom: 1),
                child: Text('Full Name',style: TextStyle(fontSize: 18,
                  color: Colors.white70,fontWeight: FontWeight.w600),),
              )) ),
              Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                child: Container(
                  width: width,
                  height: height,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                 return 'Please enter userName.';
                        
                      } else if(!validateUserName(value)) {
                        return 'Only Alphabets are allowed in a username';
                      }
                      else{
                        return null;
                      }
                    },
                     decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 195, 203, 209),
                      
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      )
                      ,
                     ),
                  ),
                ),
              )),// TEXT FIELD COMPLETE
                Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: const EdgeInsets.only(left: 13,bottom: 1),
                child: Text('E-mail',style: TextStyle(color: Colors.white70,fontSize: 18,fontWeight: FontWeight.w600),),
              )) ),
              Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                child: Container(
                  width: width,
                  height: height,
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
                      fillColor: Color.fromARGB(255, 195, 203, 209),
                      
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      )
                      ,
                     ),
                  ),
                ),
              )),// TEXT FIELD COMPLETE
              const Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 13,bottom: 1),
                child: Text('Password',style: TextStyle(color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600),),
              )) ),
              Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                child: SizedBox(
                  width: width,
                  height: height,
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
                      fillColor: Color.fromARGB(255, 195, 203, 209),
                      
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      )
                      ,
                     ),
                  ),
                ),
              )),// TEXT FIELD COMPLETE
              Spacer(flex: 1,),
              Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: InkWell(
                  onTap: () {
                    if (_signUpFormKey.currentState!.validate()) {
                      createAccount();
                } else {
                  
                 }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                    
                    child: Center(child: Text("create your account",style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.w700),)),
                  ),
                ),
              )),
              
              // Expanded(flex: 1,child: Padding(
              //   padding: const EdgeInsets.only(left: 15,right: 15),
              //   child: RoundButton(btnName: 'SIGN UP', voidCallback: (){
              //   if (_signUpFormKey.currentState!.validate()) {
              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successfully')));
              //   } else {
                  
              //   }
              //   }, textStyle: TextStyle(
              //     color: Color.fromARGB(255, 31, 30, 30)
              //   )),
              // )),
         
         
                  
                  Spacer(flex: 1,)
                ],
              ),
            ),
            ),
        ),
      ),
    );
  }
}