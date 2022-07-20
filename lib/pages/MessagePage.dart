import 'package:flutter/material.dart';
import 'package:learning/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  TextEditingController messageController = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();
  var messages = [];

  void _scrollDown() {
    _controllerScroll.jumpTo(_controllerScroll.position.maxScrollExtent);
  }

  @override
  void initState(){
    super.initState();
    //_scrollDown();
  }

  Future<void> sendMessage(text) async{
   // var docRef = FirebaseFirestore.instance.collection("messages").doc('${AuthConst.userName}=${MessageUser.targetUser}');

    //FirebaseFirestore.instance.collection('items').add({'item': _userTodo});
    if(text=='') return;
    FirebaseFirestore.instance.collection('messages').doc('${DateTime.now()}').set({
      'recipient': MessageUser.targetUser,
      'sender': AuthConst.userName,
      'text': text,
      'time': "${(DateTime.now().hour).toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}"
    });


  }

  int countOfMessages(var docs){
    int res = 0;
    docs.forEach((el) async{
      if(el.get('sender') == AuthConst.userName && el.get('recipient') == MessageUser.targetUser
          || el.get('recipient') == AuthConst.userName && el.get('sender') == MessageUser.targetUser){
        messages.add(el.get('text'));
        res++;
      }
    });
    return res;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MessageUser.targetUser),
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
                        Text('${AuthConst.userName}!',
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
              leading: const Icon(Icons.message_outlined,),
              title: const Text('Direct'),
              onTap: ()async{
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/direct');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child:
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('messages').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData || snapshot.data!.docs == []) {
                        return const Center(child: CircularProgressIndicator(),);
                      } else {
                        var len = countOfMessages(snapshot.data!.docs);
                        return ListView.builder(
                            //controller: _controllerScroll,
                            shrinkWrap: true,
                            itemCount: len,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                width: 100,
                                decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                child: ListTile(
                                    title: Text(messages[index])
                                ),
                              );
                            }
                        );
                      }
                    },
                  ),
          ),
          Row(
          children: [
            // First child is TextInput

            Expanded(

                child: Container(
                color: Colors.grey.shade900.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 0),
                    child: TextFormField(
                      controller: messageController,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: "Text message...",
                        labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                        fillColor: Colors.blue,
                        border: InputBorder.none
                      ),
                    ),
                  )
                )
            ),
            // Second child is button
            Ink(
              //padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
              height: 58,
              decoration: BoxDecoration(
                color:  Colors.grey.shade900.withOpacity(0.7),
                shape: BoxShape.rectangle,

              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,


                onPressed: () {
                  messages.add(messageController.text);
                  sendMessage(messageController.text);

                  //MessageUser.dialogs.add();
                  //_scrollDown();
                  //countOfMessages();
                  messageController.text = '';
                },
              ),
            ),
          ]
          )
        ],
      ),

        );

  }
}
