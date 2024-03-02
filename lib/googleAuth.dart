import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class GoogleAuth{
  handleSignInWithGoogle(BuildContext context) async {
    try {
      // Initialize GoogleSignIn
      GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign in with Google
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {

        // Get GoogleSignInAuthentication
        GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
        print("running...............checked google auth....");
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        print("running...............checked crenditial....");

        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        print("running...............user credential....");

        // Access user details
        User? user = userCredential.user;
        String? userEmail = user!.email;
        String? userName = user.displayName;
        String? uid = user.uid;
        String? proPic = user.photoURL;


        print("running...................$userName..$userEmail..$uid....$proPic");

        if(userCredential.user !=null){
          print("dfnbnsfnnds..............");

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextSc(),));
        }
      } else {
        // User cancelled sign-in process
      }
    } catch (e) {

      null;
    }
  }
}