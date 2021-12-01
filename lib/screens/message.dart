import 'package:flutter/material.dart';
import 'package:akyatbukid/messages/messagee.dart';
import 'package:akyatbukid/Models/MessageModel.dart';

class ConversationList extends StatefulWidget{
  final String uid;
  String fname;
  String lname;
  String usertype;
  String profilePicture;
  String timestamp;
  String chatMessage;
  bool isMessageRead;
  ConversationList({
    this.uid,
    this.fname,
    this.lname,
    this.profilePicture,
    this.chatMessage,
    this.timestamp,
    this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}
class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilePicture),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.lname, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.chatMessage,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.timestamp,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}