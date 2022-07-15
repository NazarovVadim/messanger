import 'package:flutter/material.dart';
import 'package:learning/const.dart';
import 'const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'const.dart';




class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}





class _NewMessageState extends State<NewMessage> {

  late List users = [];


  @override
  void initState(){
    super.initState();
     //getUsers();
    // print(users);
  }

  void getUsers() async{
    List b = [];
    print(FirebaseFirestore.instance.collection('items').snapshots());
    FirebaseFirestore.instance.collection('users').get().then((value){
      //var a = value.docs.map(doc => doc.data());

      var a = value.docs.map((e) => e.data()); //  все пользователи

      a.forEach((element) {
        String currentName = element["user"];

        if(currentName != AuthConst.userName){
          users.add(currentName);
        }
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message...'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
           if(!snapshot.hasData) return const Text('No users');
           print(snapshot.data!.docs);
           return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (BuildContext context, int index){
               if(snapshot.data!.docs[index].get('user') != AuthConst.userName){
                 return  Card(
                     child: Column(
                       mainAxisSize: MainAxisSize.max,
                       children: <Widget>[
                         ListTile(
                           leading: CircleAvatar(
                             backgroundColor: Colors.blue,
                             radius: 40.0,
                             child: Icon(
                               Icons.account_circle_outlined,
                               size: 40,

                               color: Colors.white.withOpacity(0.7),
                             ),
                           ),
                           title: Text(snapshot.data!.docs[index].get('user')),
                           subtitle: Text('Message'),
                         ),
                       ],
                     )
                 );
               }
               else return const Padding(padding: EdgeInsets.zero);

             },
           );
        },
      ),
    );
  }
}
