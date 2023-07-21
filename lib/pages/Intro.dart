import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yonketa_new/pages/menupage.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final CollectionReference<Map<String, dynamic>> players  = FirebaseFirestore.instance.collection('EnteredPlayers');
  final CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  String name = '';
  String takennicknameerror = '';
  String playerid = '';
  String roomid = '';

  @override
  void initState() {
    addtoFB();
    super.initState();
  }
  addtoFB()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await players.add({});
    await rooms.add({});
    setState(() {
      roomid = prefs.getString('roomid') ?? '';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: players.snapshots(),
      builder: (context, playerssnapshot) {
        if(!playerssnapshot.hasData){
            print('introPL snapshot yok');
            return const Scaffold(body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(child: Text('Game preparing to start..',style: TextStyle(fontSize: 30,letterSpacing: 5),),),
              Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,)),
            ],
                  ));
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: rooms.snapshots(),
          builder: (context, roomssnapshot) {
            if(!roomssnapshot.hasData){
                print('introRM snapshot yok');
                return const Scaffold(body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: Text('Rooms preparing to start..',style: TextStyle(fontSize: 30,letterSpacing: 5),),),
                  Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,)),
                ],
                      ));
            }
           // for (var doc in roomssnapshot.data!.docs) { 
           //   if(doc.id == roomid){
           //     rooms.doc(roomid).delete();
           //   }
           // }
            return Scaffold(
              //backgroundColor: Color.fromARGB(255, 90, 71, 15),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(134, 255, 191, 0),
                title: Row(
                  children: [
                    const Expanded(flex: 3,child: Text(''),),
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
                image: AssetImage("assets/paper.png"),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
                 ),
                    child: Column(children: [
                    SizedBox(height: height*0.30,),
                    SizedBox(height: 50,child: Center(child: Text('Enter Your Nickname',style: GoogleFonts.pacifico(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 30,decoration: TextDecoration.none),),),),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        
                        side:  const BorderSide(color: Color.fromARGB(255, 0, 0, 0),width: 1),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          cursorColor: Colors.brown,
                          style: GoogleFonts.pacifico(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 4),
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (v)=>setState(() {
                            name = v;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1,),
                    Center(child: Text(takennicknameerror,style:GoogleFonts.pacifico(color: Colors.redAccent,fontSize: 20,decoration: TextDecoration.none,letterSpacing: 4),),),
                    const SizedBox(height: 4,),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(onPressed: (){
                                if(playerssnapshot.data!.docs == []){
                                  print('a');
                                   setState(() {
                                    takennicknameerror = '';
                                  });
                                  players.add({'name':name});
                                  for (var e in playerssnapshot.data!.docs) {
                                    e.data().isEmpty ? players.doc(e.id).delete() : true;
                                  }
                                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MenuPage(name: name,)), );
                                }
                                 else if(playerssnapshot.data!.docs.any((e) => e.data().values.any((v) => v == name || name == ''))){
                                    print('b');
                                   setState(() {
                                     takennicknameerror = 'Enter a valid nickname';
                                   });
                                   
                                 }
                                 else{
                                  //for (var e in playerssnapshot.data!.docs) {
                                  //  print(e.data().isEmpty);
                                  //}
                                    setState(() {
                                     takennicknameerror = '';
                                   });
                                   players.add({'name':name}).then((doc) {
                                    setState(() {
                                      playerid = doc.id;
                                    });
                                   });
                                   for (var e in playerssnapshot.data!.docs) {
                                     e.data().isEmpty ? players.doc(e.id).delete() : true;
                                   }
                                   Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MenuPage(name: name,)), );
                                 }
                       
                      },
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                        backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(165, 255, 183, 0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          )
                        )
                       ), 
                      child: Container(margin: const EdgeInsets.all(15),child: Text('START',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.black),)),
                      ),
                    ),
                    ]),
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}