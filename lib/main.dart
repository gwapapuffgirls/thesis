import 'package:akyatbukid/login.dart';
import 'package:akyatbukid/navbar.dart';
import 'package:akyatbukid/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Models/UserModel.dart';
import 'Services/authServices.dart';
import '/messages/chatFrame.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'screens/profile.dart';
// import 'package:provider/provider.dart';

// import 'package:akyatbukid/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget getScreenId() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return NavPage(currentUserId: snapshot.data.uid);
          } else {
            return MaterialApp(
              home: HomePage(),
              routes: {
                SignupPage.id: (context) => SignupPage(),
                LoginPage.id: (context) => LoginPage(),
                ChatPage.id: (context) => ChatPage(),
                ProfilePage.id: (context) => ProfilePage()
                
      
              });
          }
        });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return 
       MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: getScreenId(),
      // ),
    );
  }
}

