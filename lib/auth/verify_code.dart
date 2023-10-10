import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:wechat/screens/home_screen.dart';

import '../utility/dialogs.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  String otp = '';

  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 100,left: 8,right: 8),
        child: Column(
          children: [
            const Icon(CupertinoIcons.lock,size: 150,color: Colors.black,),
            const SizedBox(height: 50),
            const Text(
              'Enter Your OTP',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 40.0),
            OTPTextField(
              keyboardType: TextInputType.text,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                 otp =  pin;
                 print("Completed otp is: "  +otp.toString());

              },
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  onPressed: () async {
                    final crendital = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                       smsCode: otp,
                    );
                    try {
                      await auth.signInWithCredential(crendital);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()));
                    } catch (e) {
                      Dialogs.showSnackbar(context, 'User Not Verified');
                    }
                  },
                  child: const Text('Verify',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
            ),
          ],
        ),
      ),
    );
  }
}
