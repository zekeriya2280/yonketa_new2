import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yonketa_new/pages/CreateGamePage.dart';
import 'package:yonketa_new/pages/JoinGamePage.dart';
import 'package:yonketa_new/pages/wrapper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);
  @override
  State<MenuPage> createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  final CollectionReference<Map<String, dynamic>> players  = FirebaseFirestore.instance.collection('EnteredPlayers');
  final CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  String playerName = '';

  @override
  void initState(){
     addtoFB();
     roomcleaner();
    super.initState();
  }
  roomcleaner()async{
    final QuerySnapshot<Map<String, dynamic>> docs = await rooms.get();
      for (var doc in docs.docs) {
        if(doc.data()['player1'] == playerName || doc.data()['player2'] == playerName){
            await rooms.doc(doc.id).delete();
          }
      }    
  }
  addtoFB()async{
    setState(() {
      playerName = FirebaseAuth.instance.currentUser!.displayName ?? 'Player${Random().nextInt(10000)}';
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: rooms.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
       
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                const Expanded(flex: 3,child: Text(''),),
                Text('YONKETA',style: GoogleFonts.pacifico(),),
                const Expanded(flex: 2,child: Text(''),),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: ()async{
                  await FirebaseAuth.instance.signOut().then((value) => 
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper()), )
                  );
                }
              )
            ],
          ),
          body: Center(child: 
           Container(
             height: height,
             width: width,
             decoration: const BoxDecoration(
               image: DecorationImage(
            image: AssetImage("assets/paper.png"),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
          ),
             ),
             child: Column(children: [
               const Expanded(flex: 1,child: Text(''),),
               ElevatedButton(
                 
                 style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(98, 255, 157, 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      side: const BorderSide(color: Colors.red),
                    )
                  )
                 ),
                onPressed: ()async{
                  String roomid = '';
                  //print('aaaaaaaa');
                  await rooms.add({'player1' : playerName, 'player2' : ''}).then((doc) { 
                    setState(() {
                      roomid = doc.id;
                    });
                    //print('roomid : $roomid');
                    });
                  for (var doc in snapshot.data!.docs) { 
                    doc.data().isEmpty ? await rooms.doc(doc.id).delete():null; 
                  }
                  await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CreateGamePage()), );
                 },
                child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Create A Game',style: GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                ),),
               const SizedBox(height: 30,),
               ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(98, 255, 157, 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      side: const BorderSide(color: Colors.red),
                    )
                  )
                 ),
                 onPressed: (){
                 Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => JoinGamePage(name:playerName)), );
               }, child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Join A Game',style:  GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                ),),
               const  SizedBox(height: 30,),
               ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(98, 255, 157, 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      side: const BorderSide(color: Colors.red),
                    )
                  )
                 ),
                 onPressed: (){}, child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:  Text('How To Play',style:  GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                ),),
               const  SizedBox(height: 30,),
               ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(98, 255, 157, 0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      side: const BorderSide(color: Colors.red),
                    )
                  )
                 ),
                 onPressed: () => SystemNavigator.pop(), child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:  Text('Quit',style:  GoogleFonts.pacifico(fontSize: 30,color: Colors.black),),
                ),),
               const Expanded(flex: 1,child: Text(''),),
             ],),
           )  
          )
        );
      }
    );
  }
}