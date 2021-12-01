import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:akyatbukid/Services/authServices.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:akyatbukid/Models/UserModel.dart';
import 'package:akyatbukid/screens/profile.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/constant/constant.dart';


  final _firestroe = FirebaseFirestore.instance;

    User loggedInUser;

class ChatFrame extends StatefulWidget {
  final String currentUserId;

  const ChatFrame({Key key, this.currentUserId}) : super(key: key);
  @override
  _ChatFrameState createState() => _ChatFrameState();
}

class _ChatFrameState extends State<ChatFrame> {
  Future<QuerySnapshot> _users;
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/placeholder.png')
            : NetworkImage(user.profilePicture),
      ),
      title: Text(user.fname + ' ' + user.lname),
      onTap: () {


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        // centerTitle: true,
        elevation: 0.5,
        // but
        title: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                hintText: 'Search ...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {
                    clearSearch();
                  },
                ),
                filled: true,
              ),
              autofocus: true,
              onChanged: (input) {
                if (input.isNotEmpty) {
                  setState(() {
                    _users = DatabaseServices.searchUsers(input);

                  });
                }
              },
            ),
            
          ],
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 200),
                 
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('No users found!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                           UserModel.fromDoc(snapshot.data.docs[index]);
                           UserModel.fromDoc(snapshot.data.docs[index]);
                      return buildUserTile(user);
                    });
              }),
    );
  }
}
//CreateChat
class ChatPage extends StatefulWidget{
  static const String id = 'chatpage';
  @override


  _ChapPageState createState() => _ChapPageState();
}

class _ChapPageState extends State<ChatPage> {
  final messageTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  
  

  void getCurrentUser(){
    try{
      final User user = _auth.currentUser;
      if (user != null){
        loggedInUser = user;
        print(user.email);
        
      }
    } catch (e) {
      print(e);
    }
  }  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: null,     
        title: Text("Chat Page"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: < Widget>[
                  Expanded(child: TextField(
                    controller: messageTextController,
                    onChanged: (value){
                      messageText = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  )),
                  IconButton(
                    onPressed: (){
                      messageTextController.clear();
                     _firestroe.collection('messages').add({
                       'sender': loggedInUser.email,
                       'text': messageText,
                     });
                  }, icon: Icon(Icons.send))
                ]
              ),

            )
          ],
        )
      )
    );
  } 
}
class MessageStream  extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              stream: _firestroe.collection('messages').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange),
                  );
                }
                  final db_messages = snapshot.data.docs.reversed;
                  List<BubbleMessage> BubbleMessages = [];
                  for (var message in db_messages){
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final currentUser = loggedInUser.email;

                    if(currentUser == messageSender){

                    }
                    
                    final bubbleMessage = BubbleMessage(
                      sender: messageSender, 
                      text: messageText,
                      isMe: currentUser == messageSender);
                    
                    BubbleMessages.add(bubbleMessage);
                  }
                  return Expanded(
                    child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView(
                      reverse: true,
                    children: BubbleMessages,
                )));
                  
                }
            );
  }
}
class BubbleMessage extends StatelessWidget {
  BubbleMessage({this.sender, this.text, this.isMe});
  String sender;
  String text;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.all(8.0) ,
    child: Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text('$sender', 
        style: TextStyle(fontSize: 12, color: Colors.black45)),
    Material( 
    elevation: 5,
    borderRadius: isMe 
    ?  BorderRadius.only(topLeft: Radius.circular(15),
    bottomLeft: Radius.circular(15),
    bottomRight: Radius.circular(15)) 
    : BorderRadius.only(
    bottomLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),
    topRight: Radius.circular(15)),
    color: isMe ? Colors.lightGreen[700] : Colors.orange,
    child: Padding (
    padding: EdgeInsets.all(10.0),
    child:Text("$text",
                    style: TextStyle(fontSize: 20,
                    color: Colors.white))))]));
              
  }
  
}