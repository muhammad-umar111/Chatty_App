import 'package:flutter/material.dart';

class Helper {
  static showLoadingDialogue(BuildContext context,String title){
    AlertDialog alertDialog=AlertDialog(
      content: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text(title)
          ],
        ),
      ),
    );
    showDialog(context: context, builder:(context) {
      return alertDialog;
    },);
  }
  static showAlertDialogue(BuildContext context,String title,String content){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(content)
      ,actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
         child: const Text('ok'))
      ],
        );
      showDialog(context: context, builder:(context) {
      return alertDialog;
    },);
  }
  static showDeleteDialogue(BuildContext context,String title,String content,void Function()? onTap){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(content)
      ,actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
         child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
           children: [
             InkWell(onTap: () {
               Navigator.pop(context);
             },child: Padding(
               padding: const EdgeInsets.only(right: 12),
               child: const Text('Cancel'),
             )),

             InkWell(onTap: onTap,child: const Text('Delete')),
           ],
         ))
      ],
        );
      showDialog(context: context, builder:(context) {
      return alertDialog;
    },);
  }
  static showMenu(BuildContext context,String first,String second){
    AlertDialog alertDialog=AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Icon(Icons.settings,color: Color.fromARGB(255, 56, 1, 105),),
            Spacer(flex: 1,),
            Text(first),
            Spacer(flex: 2,)

          ],),
          Row(children: [
            Icon(Icons.logout,color: Color.fromARGB(255, 56, 1, 105)),
            Spacer(flex: 1,),
            Text(second),
            Spacer(flex: 2,)
          ],)
        ],
      )
      
      
        );
      showDialog(context: context, builder:(context) {
      return alertDialog;
    },);
  }
}
