// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning/const.dart';
//import 'package:learning/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:learning/functions.dart';



class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => _AuthorizationState();
}


class _AuthorizationState extends State<Authorization> {
  late String title;
  late String actionButtonText;
  late String changeActionText;
  late String describeActionText;
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    title = 'Authorization';
    actionButtonText = 'Log In';
    changeActionText = 'Register';
    describeActionText = 'Don\'t have an account?';
    getStorageData();

  }
  void getStorageData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('username')!=null){
      setState(() {
        userNameController.text = prefs.getString('username');
        passwordController.text = prefs.getString('password');
      });
      loginFun();
    }
  }

  Future<void> loginFun() async{
    var docRef = FirebaseFirestore.instance.collection("users").doc(userNameController.text);
    docRef.get().then((doc) async {
      //print(doc.data()?.values.first);
      if(doc.exists){
        if(doc.data()?.values.first == passwordController.text && passwordController.text.isNotEmpty){
          Navigator.pushReplacementNamed(context, '/direct');


          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', doc.data()?.values.last);
          prefs.setString('password', doc.data()?.values.first);
          AuthConst.userName = doc.data()?.values.last;
          AuthConst.password = doc.data()?.values.first;

        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect password!')),);
          passwordController.text = '';

        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username is not available')),);
        userNameController.text = '';
        passwordController.text = '';
      }
    }).catchError((e){
      throw Exception(e);
    });
  }



  Future<void> registerFun() async{
    var docRef = FirebaseFirestore.instance.collection("users").doc(userNameController.text);
    docRef.get().then((doc){
      if(doc.exists){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This username already used')),);
        userNameController.text = '';
        passwordController.text = '';
      }
      else{
        if(passwordController.text.isNotEmpty){
          if(userNameController.text.length<3){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username must be more than 3 characters long')),);
            userNameController.text = '';
            passwordController.text = '';
          }
          FirebaseFirestore.instance.collection('users').doc(userNameController.text).set(
              {
                'user': userNameController.text,
                'password': passwordController.text
              }
          );
          changeActionMethod();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You was successfully registered!')),);
        }


      }
    }).catchError((e){
      throw Exception(e);
    });

    // if(doc.exists){
    //   Navigator.pushReplacementNamed(context, '/home');
    // } else{
    //   print('user not defined');
    // }
  }

  void changeActionMethod(){
    if(title != 'Register'){
      setState((){
        title = 'Register';
        actionButtonText = 'Register';
        changeActionText = 'Log in';
        describeActionText = 'Already have an account?';
      });

    } else {
      setState((){
        title = 'Authorization';
        actionButtonText = 'Log In';
        changeActionText = 'Register';
        describeActionText = 'Don\'t have an account?';
      });
    }
    userNameController.text = '';
    passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),centerTitle: true,),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(

                    icon: Icon(Icons.person_outline_rounded),
                    hintText: 'What do people call you?',
                    labelText: 'Username',

                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'This field can not be empty';

                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock_outline_rounded),
                    //hintText: 'What do people call you?',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (String? value){
                    if (value == null || value.isEmpty) return 'This field can not be empty';
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              if(title == 'Authorization'){
                                loginFun();
                              } else{
                                registerFun();
                              }
                            }

                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),),
                          child: Text(actionButtonText)
                      ),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(describeActionText, style: const TextStyle(color: Colors.grey),),
                    TextButton(onPressed: (){
                      changeActionMethod();

                    }, child: Text(changeActionText))
                  ],
                )
              ],
            ),
          )

        ),
      )
    );
  }
}
