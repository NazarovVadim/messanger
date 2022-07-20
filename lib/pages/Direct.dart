import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning/const.dart';

import 'MessagePage.dart';

class Direct extends StatefulWidget {
  const Direct({Key? key}) : super(key: key);

  @override
  State<Direct> createState() => _DirectState();
}

class _DirectState extends State<Direct> {

  String userName= AuthConst.userName;
  var dialogsName = [];

  @override
  void initState(){
    super.initState();

  }

  int countOfUsers(var docs){
    int res = 0;

    docs.forEach((el) async{
      if((el.get('recipient') == AuthConst.userName || el.get('sender') == AuthConst.userName)) {
        String name = el.get('recipient') ==
            AuthConst.userName ? el.get('sender')
            : el.get('recipient');
        if (!dialogsName.contains(name)) {
          dialogsName.add(name);
          MessageUser.dialogs.add(name);
          res++;
        }
      }
    });
    return res;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.45)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Hello,', style: TextStyle(fontSize: 20),),
                    Text('$userName!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,

                      ),
                    ),
                  ],
                )
              )
            ),
            ListTile(
              leading: const Icon(Icons.logout,),
              title: const Text('Log out'),
              onTap: ()async{
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('username');
                prefs.remove('password');
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                //print(FirebaseFirestore.instance.collection('messages').snapshots());

                if(!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  var len = countOfUsers(snapshot.data!.docs);
                  return ListView.builder(
                      itemCount: len,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        // String name = snapshot.data!.docs[index].get('recipient') == AuthConst.userName ? snapshot.data!.docs[index].get('sender')
                        //               : snapshot.data!.docs[index].get('recipient');

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 40.0,
                              child: Icon(
                                Icons.account_circle_outlined,
                                size: 40,

                                color: Colors.white.withOpacity(0.7),
                              ),

                            ),
                            title: Text(dialogsName[index]),
                            subtitle: Text('Message'),
                            onTap: (){
                              MessageUser.targetUser = dialogsName[index];
                              Navigator.push(context,  MaterialPageRoute( builder: (context) => const MessagePage(),));
                            },
                          ),
                        );
                      }
                  );
                }

              }

            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/newMessage', (route) => true);
        },
        child: const Icon(
          Icons.message_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
