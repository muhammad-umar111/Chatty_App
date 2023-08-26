

import 'dart:developer';

import 'package:chatty_box/HomeScreens.dart/LoginScreen.dart';
import 'package:chatty_box/Models.dart/ChatRoomModel.dart';
import 'package:chatty_box/SplashScreen.dart';
import 'package:chatty_box/chat.dart/UIHelper.dart';
import 'package:chatty_box/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ChatRoomPage.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});
static const pageName='/ChatList';
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late TextEditingController searchController;
   String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

@override
void initState() {
  super.initState();
  searchController=TextEditingController();
  
}  
@override
  void dispose() {
   searchController.dispose();
    super.dispose();
  }
  Future<ChatRoomModel ?> getChatRoomModel(String targetUserId)async{
    ChatRoomModel? chatRoom;
   var snapshot =await FirebaseFirestore.instance.collection('ChatRooms').
    where('participants.$currentUserId',isEqualTo: true).
    where('participants.$targetUserId',isEqualTo: true).get();
    if(snapshot.docs.length>0){
    var  docsData=snapshot.docs[0].data();
   ChatRoomModel existingChatRoomModel=ChatRoomModel.fromMap(docsData);
   chatRoom=existingChatRoomModel;
    }
    else{
      ChatRoomModel? newChatRoomModel=ChatRoomModel(
        chatRoomId: uuid.v1(),
        chatOpen: Timestamp.fromDate(DateTime.now()),
        lastMessage: "",
        participants: {
         targetUserId:true,
         currentUserId:true

        });
    await FirebaseFirestore.instance.collection('ChatRooms').doc(newChatRoomModel.chatRoomId).set(
      newChatRoomModel.toMap()
    );
    chatRoom=newChatRoomModel;
    }
    return chatRoom;
  }
  @override
  Widget build(BuildContext context) {
  final Size size=MediaQuery.sizeOf(context);
  final height=size.height;
  final width=size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
           decoration: const BoxDecoration(
            color: Color.fromARGB(255, 27, 25, 25),
      ),
      child: Column(
        children: [
           Expanded(flex: 1,child: Row(
            children: [
              Expanded(
                flex: 2,child:Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: 
                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50)                 ),
                      child: Center(child:
                       IconButton(onPressed: (){
                        Helper.showMenu(context,'settings','Log out');
                       },
                        icon: Icon(Icons.menu,color: Colors.white,))))
                  ),
                ) ),
                    Expanded(flex: 4,child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: Text('Chats',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 27
                          ),),
                        ),
                      ),
                    )),
                    Spacer(flex: 4,),
              ],
            )),
          // First child column is ended...
                  Expanded(flex: 1,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
            child: SizedBox(
              width: width,
              height: height,
              child: TextField(
                controller:searchController,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                 
                },
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 156, 160, 163),
                  filled: true,
                  prefixIcon: InkWell(onTap: (){
                 
                  setState(() {
                    
                  });
                   
                  },
                  child: const Icon(Icons.search,color: Color.fromARGB(255, 90, 87, 87),)),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(49),
                  )
                  ,
                 ),
              ),
            ),
          )),// TEXT FIELD ENDED
 
         Expanded(flex: 1,child:Container(
           child: StreamBuilder(
            stream:FirebaseFirestore.instance.collection('User`s').
            where('username',isEqualTo: searchController.text.trim()).
            where('id',isNotEqualTo: currentUserId).
            snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState==ConnectionState.active){
                if (snapshot.hasData) {
                  if(snapshot.data!.docs.length>0){
                     return ListTile(
                      
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[0]['photoUrl'].toString()),),
                    title: Text(snapshot.data!.docs[0]['username'].toString(),style: 
                    TextStyle(color: Colors.white),),
                    trailing: IconButton(onPressed:() async{
                   ChatRoomModel? chatRoomModel= await  getChatRoomModel(
                    snapshot.data!.docs[0]['id'].toString());
                    if (chatRoomModel!=null) {
                       Navigator.pushNamed(context,ChatRoomPage.pageName,arguments:{
                         'username': snapshot.data!.docs[0]['username'].toString(),
                         'photoUrl':snapshot.data!.docs[0]['photoUrl'].toString(),
                         'chatRoomModel':chatRoomModel,
                          'currentUserId':currentUserId
                           
                        });
                    } else {
                      
                    }
                       
                    },icon:const Icon(Icons.keyboard_arrow_right,color: Colors.white70,),
                  ));
                  }
                  else{
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No result found',
                    style: TextStyle(color: Colors.grey,
                    fontSize: 18),),
                  );

                 }
                  
                } else if(snapshot.hasError){
                   return  Text('An error occur${snapshot.error.toString()}',
                   style: TextStyle(color: Colors.grey,
                    fontSize: 18));
                }else{
                  return Text('No result found',style: TextStyle(color: Colors.grey,
                    fontSize: 18));
                }
              } else {
                 return Center(child: CircularProgressIndicator(),);
              }
        
        
             
           },),
         ) ,),
         const Expanded(flex: 1,child:Align(alignment: Alignment.centerLeft
              ,child: Padding(
                padding: EdgeInsets.only(left: 13,bottom: 1),
                child: Text('Recent Chats:',style: TextStyle(fontSize: 22,
                fontStyle: FontStyle.italic,
                  color: Colors.white,fontWeight: FontWeight.w700),),
              )) ),
              Expanded(flex: 5,child:StreamBuilder(
                stream: FirebaseFirestore.instance.collection('ChatRooms').
              // where('participants.$currentUserId',isEqualTo:true).
               orderBy('chatOpen',descending: true).
               snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState==ConnectionState.active) {
                    if (snapshot.hasData) {
                       var snapshotData=snapshot.data ;              
                          return ListView.builder(
                            itemCount: snapshotData!.docs.length,
                            itemBuilder:(context, index) {
                              ChatRoomModel chatRoomModel=ChatRoomModel.fromMap(
                                snapshotData.docs[index].data());
                                log('${chatRoomModel.lastMessage},${chatRoomModel.chatOpen.toString()}');
                                Map<String, dynamic> participants=chatRoomModel.participants
                                as Map<String,dynamic>;
                                List<String> participantsKeys=participants.keys.toList();
                                participantsKeys.remove(currentUserId);
                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('User`s').
                                where('id',isNotEqualTo: currentUserId).
                               where('id',isEqualTo: participantsKeys[0]).
                                snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                     return ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(context, ChatRoomPage.pageName,
                         arguments:{
                         'username': snapshot.data!.docs[0]['username'].toString(),
                         'photoUrl':snapshot.data!.docs[0]['photoUrl'].toString(),
                         'chatRoomModel':chatRoomModel,
                          'currentUserId':currentUserId
                                                   });                                    
                                                   },
                                    leading: CircleAvatar(
                                      backgroundImage:NetworkImage(snapshot.data!.docs[0]['photoUrl']) ,),
                                  title: Text(snapshot.data!.docs[0]['username'],
                                  style: TextStyle(color: Colors.white),),
                                  subtitle:(chatRoomModel.lastMessage!='')?
                                  Text(chatRoomModel.lastMessage.toString()
                                  ,style: TextStyle(color: Colors.white),):
                                  Text('sy hi to your friend',style: TextStyle(color: Colors.grey),),
                                  );
                                  } else {
                                    return Text(snapshot.error.toString());
                                  }
                                 
                                },); 
                        }, );
                      
                    } else if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString(),
                        style: TextStyle(color: Colors.white),),
                      );
                    }else{
                      return Container();
                    }
                  } else {
                    return Center(child: CircularProgressIndicator(),);
                  }
                },) ),
                Spacer(flex: 1,)
        ],
      ),
        )
        
        
       
       
     ),
     floatingActionButton: FloatingActionButton(child: Icon(Icons.logout),onPressed: () async{
        await FirebaseAuth.instance.signOut().then((value){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully logout')));
          Navigator.pushReplacementNamed(context,LoginScreen.pageName);
        } );
      },),
     );
                      
                     

    
  }
  
}