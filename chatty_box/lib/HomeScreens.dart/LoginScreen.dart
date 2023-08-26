import 'package:chatty_box/OtpVerifiedScreen.dart';
import 'package:chatty_box/RoundButton.dart';
import 'package:chatty_box/Utils.dart';
import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/chat.dart/loginDataWithEmail.dart';
import 'package:chatty_box/chat.dart/loginDataWithPhoneNumb.dart';
import 'package:chatty_box/signIn_email.dart';
import 'package:chatty_box/signupScreen.dart';
import 'package:chatty_box/validations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
static const pageName='/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNoFormKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneController=TextEditingController();
  }
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
    
  }
 Country country=Country(
    phoneCode:'92',
     countryCode:"PK",
      e164Sc:0,
       geographic: true,
        level: 1,
         name:"Pak",
          example:"Pak",
           displayName:"Pak",
            displayNameNoCountryCode:"PK",
            e164Key:"");
  @override
  Widget build(BuildContext context) {
  final Size size=MediaQuery.sizeOf(context);
  final height=size.height;
  final width=size.width;
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Expanded(flex: 1,child: Column(
            children: [
              Expanded(
                flex: 6,child:Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13,top: 10),
                    child: SizedBox(width: width,
                    height: height,
                      child: Text(
                                  
                        'Login Account',style: TextStyle(
                          fontSize: 16,
                          fontStyle:FontStyle.italic ,
                          color: Colors.black,fontWeight: FontWeight.w900),),
                    ),
                  ),
                ) ),
                    Expanded(flex: 4,child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: Text('Hello, welcome back to our account',style: TextStyle(
                            color: Colors.grey
                          ),),
                        ),
                      ),
                    ))
              ],
            )),
          // First child column is ended....
          Spacer(flex: 1,),
          Expanded(flex: 1,child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 195, 203, 209),
                  borderRadius: BorderRadius.circular(48)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Expanded(flex: 5,child:InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,SignInWithEmail.pageName);
                        },
                        child: Container(
                          width: width*0.83,
                          height: height*0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(34)
                          ),
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: Center(child: Text('E-mail')))),
                      )),
                        Spacer(flex: 1,),
                       Expanded(flex: 5,child:InkWell(
                        onTap: () {
                          
                        },
                         child: Container(
                          width: width*0.85,
                          height: height*0.88,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(34)
                          ),
                          child: SizedBox(
                            width: width,
                            height: height,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('phone number'),
                            )))),
                       ))
                    ],),
                  ),
                ),
              ),
            ),
          )),
          // SECOND CHILD COMPLETE
          Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
          ,child: Padding(
            padding: const EdgeInsets.only(left: 13,bottom: 1),
            child: Text('Phone Number',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900),),
          )) ),
          Expanded(flex: 1,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Form(
            key: _phoneNoFormKey,
              child: Container(
                width: width,
                height: height,
                child: TextFormField(
                  controller: _phoneController,
                  
                    validator: (value) {
                       if (value!.isEmpty) {
               return 'Please enter an phone no.';
               } else if (!validatePhoneNo(value)) {
               return 'Enter phone no with country code.';
               }
               return null;
                      
                    },
                  
            
            
                   decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 195, 203, 209),
                    hintText: 'Enter phone number',
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: TextStyle(color: Colors.black),
                     
                    filled: true,
                    // suffixIcon:_phoneController.text.length>9? Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: const CircleAvatar(
                    //     backgroundColor: Color.fromARGB(255, 77, 1, 73),
                    //     child: Center(child: Icon(Icons.done,color: Colors.white,)),
                    //   ),
                    // ):null ,
                    prefixIcon: Container(
                      padding:EdgeInsets.only(top: 15,left: 7,right: 8)
                      ,child: InkWell(
                        onTap: () {
                         
                         
                          showCountryPicker(context: context, 
                          countryListTheme: CountryListThemeData(bottomSheetHeight:500),
                          onSelect:(value) {
                            setState(() {
                              
                            });
                            country=value;
                              
                           
                          });
                        },
                        child: Text('${country.flagEmoji} + ${country.phoneCode}',style:
                         TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),),
                      ),),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(49),
                    )
                    ,
                   ),
                ),
              ),
            ),
          )),// TEXT FIELD COMPLETE
           const Spacer(flex: 1,),
           Expanded(flex: 1,child: Padding(
             padding: const EdgeInsets.only(left: 15,right: 18),
             child: RoundButton(btnName: 'Request OTP',textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800
             ),voidCallback: () {
              if (_phoneNoFormKey.currentState!.validate()) {
                 sendOTP();
                
              } else {
                
              }
             },),
           )),
           // OTP CHILD IS COMPLETED
          Expanded(flex: 1,child:Padding(
            padding: const EdgeInsets.only(top: 18,bottom: 18),
            child: Center(
              child: Text
              ('or sign in with Google',style: TextStyle
              (color: Color.fromARGB(255, 88, 81, 81),),),
            ),
          )),
          Expanded(flex: 1,
                     child: InkWell(
                      onTap: () {
                          
                      _handleGoogleSignInBtn();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 1),
                        child: Container(
                          height: height,
                        width: width,decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 216, 214, 214),
                              spreadRadius: 0.3),
                              BoxShadow(
                                color: Colors.white10,
                                offset: Offset(1,1 ),
                                spreadRadius: 0.6
                                )],
                          borderRadius: BorderRadius.circular(35),border:
                           Border.all(color: Color.fromARGB(255, 244, 241, 241),
                           
                           ),
                           
                           ),child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                             
                             
                              Expanded(flex: 2,child:ClipOval(child: Image.asset('assets/images/google.png',fit: BoxFit.fill,)) ,),
                              
                            
                               Expanded(flex: 7,child: SizedBox(width: width,
                               height: height,
                                child: Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text('SignIn with Google',
                                  style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black54),),
                                )))),
                             ],
                           ),),
                      ),
                                   ),
                   ),
                   // GOOGLE BUTTON ENDED
                    Expanded(flex: 1,child:Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Spacer(flex: 1,),
                          Expanded(flex: 4,child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Not register yet?',style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic),),
                          )),
                          Expanded(flex: 4,child: InkWell(onTap: () {
                            Navigator.pushNamed(context,SignUpScreen.pageName);
                          },child: Align(alignment: Alignment.centerLeft,child: Text
                          ('Create an Account',style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic),)))),
                          Spacer(flex: 1,)
                    
                        ],
                      ),
                    )),
    
          Spacer(flex: 1,)
        ],),
      ),
    );
  }
 _handleGoogleSignInBtn(){
    Helper.showLoadingDialogue(context,'Signing..In');

   _signInWithGoogle().then((value) {
    loginWithEmail(context);
   }).onError((error, stackTrace){
  Navigator.pop(context);

  Helper.showAlertDialogue(context,'signIn With google..', error.toString());

    Utils().showMessage(message: error.toString());
   });
  }
  Future<UserCredential> _signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await firebaseAuth.signInWithCredential(credential);
}
void sendOTP() async{
  Helper.showLoadingDialogue(context,'Verifying..');
  String phoneNo='+${country.phoneCode}${ _phoneController.text.trim()}';

  firebaseAuth.verifyPhoneNumber(
    phoneNumber: phoneNo,
    verificationCompleted:(phoneAuthCredential) {
    },
     verificationFailed:(error) {
       Utils().showMessage(message: error.toString());
     },
      codeSent:(verificationId, forceResendingToken) async{        
       
       Navigator.pushReplacementNamed(context,OtpVerifiedScreen.pageName,arguments: verificationId);
      },
       codeAutoRetrievalTimeout: (verificationId) {
         
       },).onError((error, stackTrace) {
  Navigator.pop(context);
Helper.showAlertDialogue(context,"phone No Verification", error.toString());
       });

}
}