// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatUsers {
//   final String uid;
//   String fname;
//   String lname;
//   String usertype;
//   String profilePicture;
//   String timestamp;
//   String chatMessage;

//     this.uid,
//     this.fname,
//     this.lname,
//     this.profilePicture,
//     this.chatMessage,
//     this.timestamp
//   });

//   factory ChatUsers.fromDoc(DocumentSnapshot doc) {
//     return ChatUsers(
//       uid: doc.id,
//       fname: doc.data()['fname'],
//       lname: doc.data()['lname'],
//       profilePicture: doc.data()['profilePicture'],
//       chatMessage: doc.data()['chatMessage'],
//       timestamp: doc.data()['timestamp']
//     );
//   }
// }
