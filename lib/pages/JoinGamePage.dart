import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yonketa_new/pages/Game.dart';
import 'package:yonketa_new/pages/menupage.dart';

class JoinGamePage extends StatefulWidget {
  final String name;
  const JoinGamePage({ Key? key, required this.name}) : super(key: key);

  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  String joinid = '';
  String notjoiningerror = '';
  
  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: rooms.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) const CircularProgressIndicator();
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 90, 71, 15),
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
          body:  Center(
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
                  const Expanded(flex: 1,child: Text(''),),
                  SizedBox(
                     height: 50,
                     child: Center(
                       child: Text('Enter The ID',
                                 style: GoogleFonts.pacifico(
                                   color: const Color.fromARGB(255, 0, 0, 0),
                                   fontSize: 30,
                                   decoration: TextDecoration.none),
                              ),
                            ),
                  ),
                  const SizedBox(height: 10,),
                  Card(
                   margin: const EdgeInsets.symmetric(horizontal: 20),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                     side:  const BorderSide(color: Color.fromARGB(255, 0, 0, 0),width: 1),
                   ),
                   child:
                      Container(
                        child: TextField(
                          cursorColor: Colors.brown,
                          style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 2),
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (v)=>setState(() {
                            joinid = v;
                          }),
                          ),
                      ),
                  ),
                  const SizedBox(height: 10,),
                  Center(child: Text(notjoiningerror,style:GoogleFonts.pacifico(color: Colors.redAccent,fontSize: 20,decoration: TextDecoration.none,letterSpacing: 4),),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                           Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>MenuPage(name: widget.name,) ));
                       },
                       style: ButtonStyle(
                       shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                       backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(115, 255, 166, 0)),
                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(28.0),
                           side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                         )
                       )
                       ), 
                       child: Container(margin: const EdgeInsets.all(15),child: Text('BACK',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.black),)),
                      ),
                      ElevatedButton(onPressed: ()async{
                         bool canjoin = snapshot.data!.docs.any((e) => e.id == joinid);
                         print(canjoin);
                         if(canjoin) {
                           setState(() {
                           notjoiningerror = '';
                           });
                           await rooms.doc(joinid).update({'player2':widget.name});
                           Navigator.push(context,MaterialPageRoute(builder: (context) =>Game(gameid: joinid,me:'player2', name: widget.name,) ));}
                         else{setState(() {
                           notjoiningerror = 'Check the id';
                         });}
                 
                       },
                       style: ButtonStyle(
                       shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                       backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(115, 255, 166, 0)),
                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(28.0),
                           side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                         )
                       )
                       ), 
                       child: Container(margin: const EdgeInsets.all(15),child: Text('START',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.black),)),
                      ),
                    ],
                  ),
                  
                  const Expanded(flex: 1,child: Text(''),),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}