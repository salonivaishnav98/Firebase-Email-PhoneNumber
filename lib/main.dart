

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'googleAuth.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyA7zjlSzcUUir-wmIpfkbXPDQtexP59uxk",
        appId: "1:835744478739:android:7ab20633f27b685110f1e6",
        messagingSenderId: "835744478739",
        projectId: "firstproject-420a2")
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final auth= FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(auth.currentUser);
    return MaterialApp(
      title: 'Flutter Demo',
      
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: auth.currentUser != null?  NextSc2():const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final auth =FirebaseAuth.instance;
  final numController =TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                child: const Text("sign with google"),onPressed: (){

                  GoogleAuth().handleSignInWithGoogle(context);

                  },
            ),

            TextField(
             controller: numController,
            ),


            ElevatedButton(
              child: const Text("Get OTP"),onPressed: (){
              auth.verifyPhoneNumber(

                phoneNumber: "+91${numController.text}",
                  verificationCompleted: (_){},
                  verificationFailed: (e){
                  print(e);
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NextSc(verificationId: verificationId),));
                  },
                  codeAutoRetrievalTimeout: (e){});

            },
            ),


          ],
        ),

    ));
  }

}
class NextSc extends StatelessWidget {
    final String? verificationId;
    NextSc({super.key,this.verificationId});
  final auth =FirebaseAuth.instance;
  final otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(
              child: const Text("go to next sc"),onPressed: (){
      
              Navigator.push(context, MaterialPageRoute(builder: (context) => NextSc2(),));
            },
            ),
            const Text("welcome"),

           TextField(
             controller: otpController,
             decoration: InputDecoration(
               border: OutlineInputBorder()
             ),
           ),
              ElevatedButton(onPressed: (){
                final credential =PhoneAuthProvider.credential(
                    verificationId: verificationId!, smsCode: otpController.text.trim());
                auth.signInWithCredential(credential).then((value){

                  print(value.user!.uid);



                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NextSc2(),), (route) => false);
                });

              }, child: Text("verify OTP"))



        ],
      )),
    );
  }
}

class NextSc2 extends StatelessWidget {
   NextSc2({super.key});
  final auth = FirebaseAuth.instance;
  final uNameController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: uNameController,),
        
            ElevatedButton(onPressed: (){

              auth.currentUser!.updateDisplayName(uNameController.text);
             
            }, child: Text("Save")),
            ElevatedButton(onPressed: (){
              print(auth.currentUser!.displayName);
            }, child: Text("Save")),
            Center(child: ElevatedButton(onPressed: (){
              GoogleSignIn().signOut();
              auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
            },child: const Text("logout")),),
          ],
        ),
      ),
    );
  }
}


