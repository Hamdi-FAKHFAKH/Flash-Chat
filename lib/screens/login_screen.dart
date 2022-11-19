import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/InputText.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String psd = '';
  double logo_size = 200;
  AnimationController controller;
  Animation animation;
  String erreur = '';
  bool spinner = false;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1), lowerBound: 0.6);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    // 2 éme type d'animation :
    // animation =
    //     ColorTween(begin: Colors.lightBlueAccent, end: Colors.indigo.shade500)
    //         .animate(controller);

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: animation.value,
      backgroundColor: Colors.indigo.shade500,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: animation.value * logo_size,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InputText(
                obs_text: false,
                OnChange: (value) {
                  email = value;
                },
                holdText: 'Enter your email',
              ),
              SizedBox(
                height: 7.0,
              ),
              InputText(
                onTap: () {
                  setState(() {
                    logo_size = 120;
                  });
                },
                obs_text: true,
                OnChange: (value) {
                  psd = value;
                },
                holdText: 'Enter your password.',
              ),
              SizedBox(
                height: 19.0,
              ),
              Text(
                erreur,
                style: TextStyle(color: Colors.red.shade200),
                textAlign: TextAlign.center,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  FocusScope.of(context).unfocus();
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: psd);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      erreur =
                          e.toString().substring(e.toString().indexOf(']') + 1);
                    });
                  }
                  setState(() {
                    spinner = false;
                  });
                },
                text: 'Log In',
              )
            ],
          ),
        ),
      ),
    );
  }
}
