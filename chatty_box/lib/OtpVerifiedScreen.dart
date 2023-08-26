import 'package:chatty_box/Utils.dart';
import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/chat.dart/loginDataWithPhoneNumb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RoundButton.dart';

// ignore: must_be_immutable
class OtpVerifiedScreen extends StatefulWidget {
  String verificationId;
   OtpVerifiedScreen({super.key,required this.verificationId});
static const pageName='/OtpVerifiedScreen';

  @override
  State<OtpVerifiedScreen> createState() => _OtpVerifiedScreenState();
}

class _OtpVerifiedScreenState extends State<OtpVerifiedScreen> {
  late TextEditingController otpController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpController=TextEditingController();
  }
  @override
  void dispose() {
      otpController.dispose();
    super.dispose();
  }
  void otpHandle()async{
    Helper.showLoadingDialogue(context,'Signing..In');
    PhoneAuthCredential phoneAuthCredential=PhoneAuthProvider.credential(
      verificationId:widget.verificationId, smsCode: otpController.text);
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential)
      .then((value) => loginWithPhoneNumber(context))
      .onError((error, stackTrace){
        Navigator.pop(context);
Helper.showAlertDialogue(context,"OTP Verification", error.toString());
        Utils().showMessage(message: error.toString());
      });
  }
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.sizeOf(context);
    final height=size.height;
    final width=size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Column(
        
        children: [
          Expanded(flex: 1,child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Align(alignment: Alignment.topLeft,child: IconButton(onPressed: () {
                  
                },icon: const Icon(
                  Icons.arrow_back_sharp,color: Colors.black,),),),
              ),
              const Expanded(flex: 5,
                child: Align(alignment:
                 Alignment.centerLeft,child: Text
                 ('OTP',style:
                  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 34),),),
              )
            ],
          )),
          // FIRST CHILD IS COMPLETE
          Expanded(flex: 3,child:ClipOval(child: Image.asset('assets/images/otps.jpg')),)
          ,Expanded(flex: 1,child: SizedBox(
            height: height,
            width: width,
            child: const Center(
              child: Text('Verification code',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.w500
              ),),
            ),
          )),
          Expanded(flex: 1,child: SizedBox(
            height: height,
            width: width,
            child: const Center(
              child: Text('We have sent the code verification to \n       Your Mobile Number',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),),
            ),
          )),
           Expanded(flex: 1,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: SizedBox(
              width: width,
              height: height,
              child: TextField(
                controller:otpController ,
                 decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 195, 203, 209),
                  
                  filled: true,
                  prefixIcon: Icon(Icons.verified,color: Colors.deepPurple,),
                  hintText: 'verification code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(49),
                  )
                  ,
                 ),
              ),
            ),
          )),// TEXT FIELD ENDED
           const Spacer(flex: 1,),
           Expanded(flex: 1,child: Padding(
             padding: const EdgeInsets.only(left: 15,right: 18),
             child: RoundButton(btnName: 'Verify',textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800
             ),voidCallback: () {
               otpHandle();
             },),
           )),
           // OTP CHILD IS COMPLETED
          const Spacer(flex: 1,)
        ],
      )),
    );
  }
}