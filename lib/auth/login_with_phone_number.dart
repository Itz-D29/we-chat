import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/auth/verify_code.dart';
import 'package:wechat/utility/dialogs.dart';

import '../main.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const Text('OTP',style: TextStyle(fontSize: 25,letterSpacing: 2,fontWeight: FontWeight.w500),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '+91 234 3455 234',
                    hintStyle: const TextStyle(color: Colors.black45),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 3
                      )
                    )
                  ),
                ),
              const SizedBox(height: 60,),
              SizedBox(
                width: mq.width * .90,
                height: mq.height * .06,
                child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      onPressed: (){
                      auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_){},
                      verificationFailed: (e){
                       Dialogs.showSnackbar(context, 'Not Verified');
                      },
                      codeSent: (String verificationID, int? token){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyCode(verificationId: verificationID,)));
                      },
                      codeAutoRetrievalTimeout: (e){
                        //Dialogs.showSnackbar(context, 'Ti');
                      });

                }, child: const Text('Login')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
