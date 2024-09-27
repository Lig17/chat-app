import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
final firebase=FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final form=GlobalKey<FormState>();
  var isLogin=true;
  var enteredEmail='';
  var enteredPassword='';
  void submit() async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }

    
    form.currentState!.save();
    if (isLogin) {
      //log users in
    } else {
      try{
          final userCredentials= await firebase.createUserWithEmailAndPassword(email: enteredEmail, password: enteredPassword);


      } on FirebaseAuthException catch (error) {
        if (error.code=='email-already-in-use'){
          //...
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );


      }

    }
      
    
  }
  @override
  
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor:Theme.of(context).colorScheme.primary,
        body:Center(
          child:SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top:30,
                    bottom:20,
                    left:20,
                    right:20,
                  ),
                  width:200,
                  child:Image.asset('assets/images/chat.png'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child:SingleChildScrollView(
                    child:Padding(
                      padding:const EdgeInsets.all(16),
                      child:Form(
                        key: form,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address'
                              ),
                              keyboardType:TextInputType.emailAddress,
                              autocorrect:false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value==null || value.trim().isEmpty||!value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;

                              },
                              onSaved:(value) 
                              {
                                enteredEmail=value!;

                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password'
                              ),
                              obscureText: true,
                              validator:(value) {
                                if (value==null || value.trim().length<6||!value.contains('@')) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved:(value) 
                              {
                                enteredPassword=value!;

                              },
                            ),
                            const SizedBox(height:12),
                            ElevatedButton(
                              onPressed:submit,
                          
                              
                              style:ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              ),
                              child:Text(isLogin ?'Login':'Signup'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(isLogin ? 'Create an account': 'I already have an account'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
