class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  String? type;
  DateTime? createOn;
  MessageModel({this.messageId,this.sender,this.text,this.seen,this.createOn,this.type});
  MessageModel.fromMap(Map<String,dynamic> map){
   messageId=map['messageId'];
    sender=map['sender'];
    text=map['text'];
    seen=map['seen'];
    createOn=map['createOn'];
    type=map['type'];
  }
  Map<String,dynamic> toMap(){
    return{
     'messageId':messageId, 
    'sender':sender,
    'text':text,
    'seen':seen,
    'createOn':createOn,
    'type':type
    };
  }
}