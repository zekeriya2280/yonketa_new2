import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yonketa_new/pages/Game.dart';
import 'package:yonketa_new/pages/menupage.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  bool copychecked = false;
  String gameid = '';
  String playerName = '';
  @override
  void initState() {
    nameAndGameIdFinder();
    super.initState();
  }
  nameAndGameIdFinder()async{
    setState(() {
      playerName = FirebaseAuth.instance.currentUser!.displayName!;
    });
    final QuerySnapshot<Map<String, dynamic>> docs = await rooms.get();
    for (var doc in docs.docs) {
      if(doc.data()['player1'] == playerName || doc.data()['player2'] == playerName){
        setState(() {
          gameid = doc.id;
        });
      }
    }
  }
  Widget copyCheck(){
    if(copychecked){
    return ElevatedButton(child:Text('Start',style: GoogleFonts.pacifico(fontSize: 25),),
                     onPressed: ()async
                       {
                        await rooms.doc(gameid).update({'gamefinished':false});
                         Future.delayed(const Duration(milliseconds: 1000), () async{
                           await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Game(me: 'player1',) ),);
                         });
                       }
                   );
    }else{
      return const Text('Start',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),);
    }
  }
  Widget copyClicked(){
    if(!copychecked){
      return ElevatedButton(
                     child: Text('Copy',style: GoogleFonts.pacifico(fontSize: 25,),),
                     onPressed: (){
                       FlutterClipboard.copy(gameid);
                       setState(() {
                         copychecked = true;
                       });
                       print(copychecked);
                       }
                   );
    }
    else{
      return const Text('Copy',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: rooms.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const CircularProgressIndicator();
        return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(134, 255, 191, 0),
            title: Row(
              children: [
                const Expanded(flex: 2,child: Text(''),),
                Text('YONKETA',style: GoogleFonts.pacifico(),),
                const Expanded(flex: 3,child: Text(''),),
              ],
            ),
      ),
      body: SingleChildScrollView(
        child: Center(
              child: Container(
                 height: height,
             width: width,
             decoration: const BoxDecoration(
               image: DecorationImage(
                 colorFilter: ColorFilter.mode(
                   Colors.white,
                   BlendMode.softLight,
                 ),
                 image: AssetImage("assets/paper.png"),
                 repeat: ImageRepeat.repeat,
                 fit: BoxFit.cover,
               ),
               ),
                child: Column(
                  children: [
                    Container(height: height*0.3,),
                    Text('Share This With Your Partner',style: GoogleFonts.pacifico(color: const Color.fromARGB(255, 224, 108, 0),fontSize: 20)),
                    const SizedBox(height: 30),
                    Text(gameid,style: const TextStyle(fontSize: 15,color:Colors.black,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 30,),
                    Row(children: [
                       const Expanded(flex: 10,child: Text(''),),
                       copyClicked(),
                       const Expanded(flex: 1,child: Text(''),),
                       copyCheck(),
                       const Expanded(flex: 10,child: Text(''),),
                    ],),
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
                  await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const MenuPage()), );
                 },
                child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('BACK TO MENU',style: GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                ),
                ),
                  const Expanded(flex: 1,child: Text(''),),  
                  ],
                ),
              ),
            ),
      ),
        );
      }
    );
  }
}