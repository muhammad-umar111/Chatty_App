import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomId;
  Map<String,dynamic>? participants;
  String? lastMessage;
  Timestamp? chatOpen;
  ChatRoomModel({this.chatRoomId,this.participants,this.lastMessage,this.chatOpen});
  ChatRoomModel.fromMap(Map<String,dynamic> map){
    chatRoomId=map['chatRoomId'];
    participants=map['participants'];
    lastMessage=map['lastMessage'];
    chatOpen=map['chatOpen'];
  }

  Map<String,dynamic> toMap(){
    return {
      'chatRoomId':chatRoomId,
      'participants':participants,
      'lastMessage':lastMessage,
      'chatOpen':chatOpen
  };
  }
}