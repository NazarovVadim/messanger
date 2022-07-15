import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning/const.dart';

class Direct extends StatefulWidget {
  const Direct({Key? key}) : super(key: key);

  @override
  State<Direct> createState() => _DirectState();
}

class _DirectState extends State<Direct> {

  String userName= AuthConst.userName;

  @override
  void initState(){
    super.initState();

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
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: const [

          ],
        ),
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
