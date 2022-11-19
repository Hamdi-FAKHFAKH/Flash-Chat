import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/InputText.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  /* fire base create instanse */
  final _auth = FirebaseAuth.instance;
  String email = '';
  String mdp = '';
  String erreur = '';
  bool spinner = false;

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.6,
    );
    animation = ColorTween(
      begin: Colors.white,
      end: Colors.indigo.shade500,
    ).animate(controller);

    controller.forward();

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
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        color: Colors.indigo,
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
                    height: 140.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InputText(
                onTap: () {
                  setState(() {
                    erreur = '';
                  });
                },
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
                    erreur = '';
                  });
                },
                obs_text: true,
                OnChange: (value) {
                  mdp = value;
                },
                holdText: 'Enter your password.',
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                erreur,
                style: TextStyle(color: Colors.red.shade200),
                textAlign: TextAlign.center,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  FocusScope.of(context).unfocus();
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: mdp);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      erreur = e.toString();
                    });
                  }
                  setState(() {
                    spinner = false;
                  });
                },
                text: 'Register',
              )
            ],
          ),
        ),
      ),
    );
  }
}
