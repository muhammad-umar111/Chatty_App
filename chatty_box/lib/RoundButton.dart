// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  final String btnName;
  final VoidCallback voidCallback;
  bool loading;
  TextStyle textStyle;
   RoundButton(
      {super.key, required this.btnName, required this.voidCallback,this.loading=false,required this.textStyle});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
    final height=size.height;
    final width=size.width;
    return SizedBox(
      child: InkWell(
        onTap: voidCallback,
        child: Center(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                //color: Color.fromARGB(255, 135, 169, 166),
                 boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 135, 169, 166),
                              spreadRadius: 0.3,
                              ),
                              BoxShadow(
                                color: Color.fromARGB(62, 123, 119, 119),
                                offset: Offset(1,0 ),
                                spreadRadius: 0.6
                                )],
                borderRadius: BorderRadius.circular(40)),
            child: Center(
              child:loading?const CircularProgressIndicator(color: Colors.white,): Text(
                btnName,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
