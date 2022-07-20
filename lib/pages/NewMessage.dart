import 'package:flutter/material.dart';
import 'package:learning/const.dart';
import 'const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'const.dart';
import 'MessagePage.dart';




class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}





class _NewMessageState extends State<NewMessage> {

  @override
  void initState(){
    super.initState();

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
           if(!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
           return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (BuildContext context, int index){
               if(snapshot.data!.docs[index].get('user') != AuthConst.userName && !MessageUser.dialogs.contains(snapshot.data!.docs[index].get('user'))){
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
                           onTap: (){
                             MessageUser.targetUser = snapshot.data!.docs[index].get('user');
                              Navigator.push(context,  MaterialPageRoute( builder: (context) => const MessagePage(),));
                           },
                         ),
                       ],
                     )
                 );
               }
               else {
                 return const Padding(padding: EdgeInsets.zero);
               }

             },
           );
        },
      ),
    );
  }
}
