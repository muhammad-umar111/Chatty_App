import 'dart:developer';
import 'dart:io';

import 'package:chatty_box/Models.dart/ChatRoomModel.dart';
import 'package:chatty_box/Models.dart/MessageModel.dart';
import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils.dart';

// ignore: must_be_immutable
class ChatRoomPage extends StatefulWidget {
   ChatRoomPage({
    super.key,required this.username,
    required this.photoUrl,
    required this.chatRoomModel,
    required this.currentUserId});
  static const pageName='/ChatRoomPage';
  String photoUrl;
  String username;
  String currentUserId;
  ChatRoomModel chatRoomModel;
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late TextEditingController messageController;
  MessageModel? messageModel;
  @override
  void initState() {
    super.initState();
    messageController=TextEditingController();
  }
  @override
  void dispose() {
messageController.dispose();
    super.dispose();
  }
  
  void sendMessage()async{
    String message=messageController.text.trim();

    DateTime date=DateTime.now();
    Timestamp timestamp=Timestamp.fromDate(date);
    messageController.clear();
    if (message.isNotEmpty) {
     messageModel=MessageModel(
     messageId: uuid.v1(),
     sender: widget.currentUserId,
     text: message,
     seen: false,
     type:'text',
     createOn: date
      );
      
      FirebaseFirestore.instance.collection('ChatRooms').doc(widget.chatRoomModel.chatRoomId).
      collection('Messages').doc(messageModel!.messageId).
      set(messageModel!.toMap());
      // var type=await FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomModel.chatRoomId)
      // .collection('Messages').doc(messageModel!.messageId).get();
      //  type=await type.get('type');

      log('message sent');
      widget.chatRoomModel.lastMessage=message;
      widget.chatRoomModel.chatOpen=timestamp;
      FirebaseFirestore.instance.collection('ChatRooms').doc(widget.chatRoomModel.chatRoomId).
      set(widget.chatRoomModel.toMap());
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context,) {
    final username=widget.username;
    final photoUrl=widget.photoUrl;
    
    return Scaffold(
      
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 1, 9, 69),
         automaticallyImplyLeading: false,
           title: Row(
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon:Icon(Icons.arrow_back,color: Color.fromARGB(255, 232, 231, 232),))
            ,CircleAvatar(backgroundImage: NetworkImage(photoUrl),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(username,style: TextStyle(fontStyle: FontStyle.italic,color: Colors.white,fontWeight: FontWeight.w700),),
            ),
            Spacer(flex: 3,)
                          
            ],
           ),
          ),
          body: Column(
            children: [
              Expanded(child: messages(context,)
              //   child: StreamBuilder(
              //     stream: FirebaseFirestore.instance.collection('ChatRooms').
              //     doc(widget.chatRoomModel.chatRoomId).collection('Messages')
              //     .orderBy('createOn',descending: true).snapshots(),
              //     builder: (BuildContext context,snapshot) {

              //     if (snapshot.connectionState==ConnectionState.active) {
              //       if (snapshot.hasData) {
              //         return ListView.builder(
              //           reverse: true,
              //           itemCount: snapshot.data!.docs.length,
              //           itemBuilder: (context, index) {
              //             String sender=snapshot.data!.docs[index]['sender'].toString();
              //           return Row(
              //             mainAxisAlignment: sender==widget.currentUserId?MainAxisAlignment.end:MainAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding:sender==widget.currentUserId? const EdgeInsets.only(right: 3,bottom: 3):EdgeInsets.only(left: 3,bottom: 3),
              //                 child: Container(
              //                   padding: EdgeInsets.all(18.0),
              //                   decoration: BoxDecoration(
              //                     color:sender==widget.currentUserId? 
              //                     Color.fromARGB(255, 217, 229, 231):
              //                     Color.fromARGB(255, 33, 7, 116),
              //                     borderRadius: BorderRadius.circular(22),

              //                   ),
              //                   child: Text(snapshot.data!.docs[index]['text'].toString(),
              //                   style: TextStyle(
              //                     color:sender==widget.currentUserId?
              //                     Color.fromARGB(255, 2, 35, 68):
              //                     Color.fromARGB(255, 255, 255, 255),fontWeight:FontWeight.w600 ,
              //                     fontStyle: FontStyle.italic),),
              //                 ),
              //               ),
              //             ],
              //           );
              //         },);
              //       } else if(snapshot.hasError){
              //         return Center(child: Text(snapshot.error.toString()),);
              //       }
              //       else{
              //         return Text('Say Hi! to your new Friend',
              //         style: TextStyle(color:Color.fromARGB(255, 6, 3, 69) ,
              //         fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),);

              //       }
              //     } else {
              //       return Center(child: CircularProgressIndicator(),);
              //     }
                  
              //     },
              //   ),
              //   ),
              ),
              Container(
                color: Color.fromARGB(255, 229, 224, 224),
                padding: EdgeInsets.symmetric(horizontal: 8,vertical:3 ),
                child: Row(
                  children: [
                    Flexible(child: Padding(
                      padding: const EdgeInsets.only(left:3),
                      child: TextField(
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          border: InputBorder.none,
                          
                        ),
                      ),
                    )),
                    IconButton(onPressed: (){
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
                    }, icon:Icon(Icons.photo)),
                    IconButton(onPressed: () {
                      sendMessage();
                    }, icon:Icon(Icons.send_outlined,color: Color.fromARGB(255, 28, 1, 86)))
                  ],
                ),
              )
            ],
          ),
    );
  }
  Widget messages(BuildContext context){
    return  StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ChatRooms').
      doc(widget.chatRoomModel.chatRoomId).collection('Messages').
      // where('participants.${widget.currentUserId}',isEqualTo: true).
      
      orderBy('createOn',descending: true).snapshots(),
      builder: (BuildContext context,snapshot) {

      if (snapshot.connectionState==ConnectionState.active) {
        if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String sender=snapshot.data!.docs[index]['sender'].toString();
            return Row(
              mainAxisAlignment: sender==widget.currentUserId?MainAxisAlignment.end:MainAxisAlignment.start,
              children: [
                Padding(
                  padding:sender==widget.currentUserId? const EdgeInsets.only(right: 3,bottom: 3):EdgeInsets.only(left: 3,bottom: 3),
                  child: Container(
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color:sender==widget.currentUserId? 
                      Color.fromARGB(255, 217, 229, 231):
                      Color.fromARGB(255, 33, 7, 116),
                      borderRadius: BorderRadius.circular(22),

                    ),
                    child: InkWell(
                      onLongPress: () {
                        var docs=snapshot.data!.docs[index].data();
                        
                        Helper.showDeleteDialogue(context,
                        'Message Deletion','Are you sure to delete this message',(){
                          Navigator.pop(context);
                          FirebaseFirestore.instance.collection('ChatRooms').
      doc(widget.chatRoomModel.chatRoomId).collection('Messages').doc(messageModel?.messageId).delete();
                        }
                        );                      },
                      child: Text(snapshot.data!.docs[index]['text'].toString(),
                      style: TextStyle(
                        color:sender==widget.currentUserId?
                        Color.fromARGB(255, 2, 35, 68):
                        Color.fromARGB(255, 255, 255, 255),fontWeight:FontWeight.w600 ,
                        fontStyle: FontStyle.italic),),
                    ),
                  ),
                ),
              ],
            );
          },);
        } else if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()),);
        }
        else{
          return Text('Say Hi! to your new Friend',
          style: TextStyle(color:Color.fromARGB(255, 6, 3, 69) ,
          fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),);
        }
      } else {
        return Center(child: CircularProgressIndicator(),);
      } },
    );}

File? imageFile;
  ImagePicker picker=ImagePicker();
  void getImage(ImageSource source)async{
  final pickerFile=await picker.pickImage(source: source);
  if (pickerFile!=null) {
    
      imageFile=File(pickerFile.path);
      uploadImage();
    
  } else {
    Utils().showMessage(message:'No Image has been Picked');
  }
  }
 Future uploadImage()async{
  String? fileName=widget.chatRoomModel.chatRoomId;
  Reference ref=FirebaseStorage.instance.ref('Images/'+'$fileName');
  var uploadTask=await ref.putFile(imageFile!.absolute);
   String imageUrl=await uploadTask.ref.getDownloadURL();
 }
 
}