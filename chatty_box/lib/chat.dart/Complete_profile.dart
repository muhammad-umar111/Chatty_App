import 'dart:io';

import 'package:chatty_box/Utils.dart';
import 'package:chatty_box/chat.dart/ChatList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../validations.dart';
import 'UIHelper.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});
  static const pageName='/CompleteProfile';

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final firebaseAuth=FirebaseAuth.instance.currentUser;
  final firestore=FirebaseFirestore.instance.collection('User`s');
  final _completeFormKey=GlobalKey<FormState>();
  late TextEditingController _userName;
  File? imageFile;
  ImagePicker picker=ImagePicker();
  void getImage(ImageSource source)async{
  final pickerFile=await picker.pickImage(source: source);
  if (pickerFile!=null) {
    setState(() {
   cropImage(pickerFile);      
    });
  } else {
    Utils().showMessage(message:'No Image has been Picked');
  }
  }
  void cropImage(XFile file)async{
   final croppedImage=await ImageCropper().cropImage(
    sourcePath: file.path,
    compressQuality: 10,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
   if (croppedImage!=null) {
     setState(() {
     imageFile=File(croppedImage.path) ;
    });
   } 
     
   
  }
    uploadImagePlusData()async{
  Helper.showLoadingDialogue(context,'Loading....');

    Reference ref=FirebaseStorage.instance.ref('UsersDp/'+'/${firebaseAuth!.uid.toString()}');
    UploadTask uploadTask= ref.putFile(imageFile!);
    TaskSnapshot taskSnapshot=await uploadTask;
     String imageUrl =await taskSnapshot.ref.getDownloadURL();
      await firestore.doc(firebaseAuth!.uid).update({
                           'username':_userName.text.trim(),
                           'photoUrl':imageUrl,                           
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Completed')));
                          Navigator.pushReplacementNamed(context, ChatList.pageName);
                        }).onError((error, stackTrace) {
  Navigator.pop(context);

  Helper.showAlertDialogue(context,'Profile Completion', error.toString());

                        });
   }
  
  
  @override
  void initState() {
    super.initState();
    _userName=TextEditingController();
  }
  @override
  void dispose() {
   _userName.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.sizeOf(context);
    final width=size.width;
    final height=size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Opacity(
        opacity: 1,
        child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/background.jpg',),fit: BoxFit.cover)
     
      ),
       child: Form(
        key: _completeFormKey,
         child: Column(
         children: [
          const Spacer(flex: 1,),
         
         
          const Expanded(flex: 1,child:Center(
            child: Text(
              'COMPLETE YOUR PROFILE',style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500),),
            )),
            Expanded(flex: 3,child: InkWell(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('Upload Profile Picture',
                    style: TextStyle(color: Color.fromARGB(255, 53, 1, 62)),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_album_outlined,color: const Color.fromARGB(255, 81, 53, 86),),
                          title: InkWell(onTap: () { 
                            Navigator.pop(context);
                            getImage(ImageSource.gallery);},
                            child: Text('Select from Gallery')),
                        ),
                         ListTile(
                          leading: Icon(Icons.camera_alt,color: const Color.fromARGB(255, 102, 27, 116),),
                          title: InkWell(onTap: () { 
                            Navigator.pop(context);
                            getImage(ImageSource.camera);},
                            child: Text('Take a photo')),
                        )
                      ],
                    ),
                  );
                },);
              },
           
           
              child: CircleAvatar(minRadius: 40,
              maxRadius: 102,
              backgroundImage:(imageFile!=null)?FileImage(imageFile!,):null,

               child:imageFile==null?Center(child: Icon(Icons.person)) :null,
              )
              )
              ),
             const Expanded(flex: 1,child:Align(alignment: Alignment.bottomLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 13,bottom: 1),
                child: Text('User Name',style: TextStyle(fontSize: 18,
                  color: Colors.white70,fontWeight: FontWeight.w600),),
              )) ),
              Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 0),
                child: Container(
                  width: width,
                  height: height,
                  child: TextFormField(
                    controller: _userName,
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
              )),
             
             
                Spacer(flex: 1,),
                  Expanded(flex: 1,child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29,vertical: 3),
                child: InkWell(
                  onTap: () async{
                    if (_completeFormKey.currentState!.validate()) {
                     
                     uploadImagePlusData();
                   
                  }},
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 8, 111, 190),
                        borderRadius: BorderRadius.circular(5)),
                      
                      child: const Center(child: Text("SUBMIT",style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16,fontStyle: FontStyle.italic),)),
                    ),
                  ),
                ),
              )),
              Spacer(flex: 2,)

            ])  ),)
    ));
  }
  
}