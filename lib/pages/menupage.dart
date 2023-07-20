import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yonketa_new/pages/CreateGamePage.dart';
import 'package:yonketa_new/pages/JoinGamePage.dart';

class MenuPage extends StatefulWidget {
  final String name;
  const MenuPage({Key? key, required this.name}) : super(key: key);

  

  @override
  State<MenuPage> createState() => _MenuPageState();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class _MenuPageState extends State<MenuPage> {
  final CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  String playerName = '';

  @override
  void initState(){
    playerName = widget.name;
     roomcleaner();
    super.initState();
  }
  roomcleaner()async{
    final QuerySnapshot<Map<String, dynamic>> docs = await rooms.get();
      for (var doc in docs.docs) {
        if(doc.data()['player1'] == widget.name || doc.data()['player2'] == widget.name){
            await rooms.doc(doc.id).delete();
          }
      }    
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
                const Expanded(flex: 2,child: Text(''),),
                Text('YONKETA',style: GoogleFonts.pacifico(),),
                const Expanded(flex: 3,child: Text(''),),
              ],
            ),
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
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String roomid = '';
                  print('aaaaaaaa');
                  await rooms.add({'player1' : playerName, 'player2' : ''}).then((doc) { 
                    setState(() {
                      roomid = doc.id;
                    });
                    print('roomid : $roomid');
                    });
                  for (var doc in snapshot.data!.docs) { 
                    doc.data().isEmpty ? await rooms.doc(doc.id).delete():null; 
                  }
                  await prefs.setString('roomid', roomid);
                  await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => CreateGamePage(name : playerName ,gameid: roomid,)), );
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