import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yonketa_new/pages/menupage.dart';

class Game extends StatefulWidget {
  final String gameid;
  final String me;
  final String name;
  const Game({ Key? key, required this.gameid,required this.me,required this.name}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
class _GameState extends State<Game> {
  CollectionReference<Map<String, dynamic>> rooms  = FirebaseFirestore.instance.collection('Rooms');
  late Timer _timer;
  int _start = 10;
  dynamic thenumber = '';
  String thenumbererror = '';
  String thepopupnumbererror = '';
  String thenumberchangingerror = '';
  bool numberEntered = false;
  String theguess = '';
  bool starttimer = false;
  bool shuffled = false;
  bool numberChanged = false;
  bool fasted = false;
  bool player1won = false;
  bool player2won = false;
  dynamic guessnumberchanging;
  final _controller = TextEditingController();
  bool gamefinished = false;

  

@override
  void initState() {
    startTimer();
    wonplayerckeckerFN();
    super.initState();
  }

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
void startTimer() {
  const oneSec = Duration(seconds: 1);
  _timer = Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}
void wonplayerckeckerFN()async{
  await rooms.doc(widget.gameid).update({'whowon':''});
}
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
bool isInteger(dynamic value) => int.tryParse(value.toString()) != null;
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
 showBottomSheet({required CollectionReference<Map<String, dynamic>> rooms,required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot}){
   showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 1000,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Container(
                          
                          child: Card(
                            color:Colors.grey,
                            child: Container(
                              child: Column(
                              children: [
                                const SizedBox(height: 10,),
                                Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side:  const BorderSide(color: Color.fromARGB(255, 0, 0, 0),width: 1),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      cursorColor: Colors.brown,
                                      style: GoogleFonts.pacifico(fontSize: 24,fontWeight: FontWeight.bold,letterSpacing: 4),
                                      decoration: const InputDecoration(border: InputBorder.none),
                                      onChanged: (v)=>setState(() {
                                        thenumber = int.tryParse(v.toString());
                                        
                                      }),
                                    ),
                                  ),
                                ),
                                Center(child: Text(thenumbererror,style:GoogleFonts.pacifico(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 15,decoration: TextDecoration.none,letterSpacing: 4),),),
                                const SizedBox(height: 1,),
                                ElevatedButton(onPressed: (){
                                  if(isInteger(thenumber)){
                                    print('a');
                                    if((int.parse(thenumber.toString())*0.001).toInt() >= 1 && (int.parse(thenumber.toString())*0.001).toInt() < 10){
                                      print('b');
                                      setState(() {
                                      thenumbererror = '';
                                      });
                                      String number = thenumber.toString();
                                      print(number.split('')[0]);
                                      if(number.split('')[0] != number.split('')[1] &&
                                         number.split('')[0] != number.split('')[2] &&
                                         number.split('')[0] != number.split('')[3] &&
                                         number.split('')[1] != number.split('')[2] &&
                                         number.split('')[1] != number.split('')[3] &&
                                         number.split('')[2] != number.split('')[3]
                                      ){
                                            setState(() {
                                              numberEntered = true;
                                            });
                                            widget.me == 'player1' ? 
                                                rooms.doc(widget.gameid).update({'player1number' : int.parse(number)}) : 
                                                rooms.doc(widget.gameid).update({'player2number' : int.parse(number)});
                                            rooms.doc(widget.gameid).update({
                                                       'player1guessnumbers' : List<String>.generate(20,(counter) => ''),
                                                       'player2guessnumbers' : List<String>.generate(20,(counter) => ''),});
                                            Navigator.of(context).pop();
                                      }
                                      else{
                                        setState(() {
                                      thenumbererror = 'Enter a 4 different digit number';
                                    });
                                      }
                                    }
                                    else{
                                    print('d');
                                    setState(() {
                                      thenumbererror = 'Enter a 4 digit number';
                                    });
                                  }
                                  }
                                  else{
                                    print('c');
                                    setState(() {
                                      thenumbererror = 'Enter a 4 digit number';
                                    });
                                  }
                                }, 
                                 style: ButtonStyle(
                                   shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                                   backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(137, 255, 149, 0)),
                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                     RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(28.0),
                                       side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                                     )
                                   )
                                   ), 
                                   child: Container(margin: const EdgeInsets.all(15),child: Text('START',style: GoogleFonts.pacifico(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
                                ),
                              ],
                           ),
                            )
                          ),
                        ),
                      );
                    },
                  );
          }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 AlertDialog winAlert(String wonPlayerName,guessednumber, CollectionReference<Map<String, dynamic>> rooms){
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  return AlertDialog(

        backgroundColor: const Color.fromARGB(0, 56, 79, 117),
        //content: 
        actions: [
           Center(
             child: Container(
               child: Column(
                 children: [
                   SizedBox(
                     height: height*0.6,
                     width: width*0.9,
                     child: Card(
                             color: const Color.fromARGB(97, 26, 255, 0),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(25.0),
                             ),
                             child: Container(
                               color: Colors.transparent,
                               margin: const EdgeInsets.symmetric(horizontal: 10),
                               child: Padding(
                                   padding: const EdgeInsets.all(15.0),
                                   child: Column(
                                     children: [
                                       Center(child: Text(guessednumber,style: GoogleFonts.pacifico(fontSize: 40,fontWeight: FontWeight.bold))),
                                       SizedBox(height: height*0.13,child: const Text(''),),
                                       Center(child: Text(wonPlayerName,style: GoogleFonts.pacifico(fontSize: 40,fontWeight: FontWeight.bold))),
                                       Center(child: Text('WINNER',style: GoogleFonts.pacifico(fontSize: 40,fontWeight: FontWeight.bold))),
                                       const SizedBox(height: 10,child: Text(''),),
                                     ],
                                   ),
                         ),
                             ),
                           ),
                   ),
                   const SizedBox(height: 10,),
                   TextButton(
                     
                     style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                          backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(125, 255, 157, 0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                            )
                          )
                         ), 
                        child: Container(width: 200,margin: const EdgeInsets.all(30),child: Center(child: Text('BACK TO MENU',style: GoogleFonts.pacifico(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),))),
       
                     onPressed: ()async {
                       await rooms.doc(widget.gameid).delete();
                       await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>MenuPage(name: widget.name) ));}
                   ),
                   const SizedBox(height: 2,child: Text(''),)
                 ],
               ),
             ),
           )
        ],
      );  
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Widget> oneNumbersManagerListWidget({required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot}){
    
    List<dynamic> listwidget = List<Widget>.generate(100,(counter) => const Text(''));
    int plusses = 0;
    int minuses = 0;
    for (var doc in snapshot.data!.docs) {
      if(doc.id == widget.gameid){
        if(doc.data()['player1guessnumbers'] != null){
             List<String> ls = List<String>.from(doc.data()['player1guessnumbers']);
             String opponentnumber = doc.data()['player2number'].toString();
             if(ls != null){
                for (var i = 0; i < ls.length; i++) {
                  if(ls[i] != ''){
                      if(ls[i].split('')[0] == opponentnumber.split('')[0] ){plusses++;}
                      if(ls[i].split('')[1] == opponentnumber.split('')[1] ){plusses++;}
                      if(ls[i].split('')[2] == opponentnumber.split('')[2] ){plusses++;}
                      if(ls[i].split('')[3] == opponentnumber.split('')[3] ){plusses++;} 
                      //////////////////////////////////////////////////////////////////////////
                      for (var k = 0; k < ls[i].split('').length; k++) {
                        for (var j = 0; j < opponentnumber.split('').length; j++) {
                          if(k != j){
                             if(ls[i].split('')[k] == opponentnumber.split('')[j] ){minuses++;}
                          }
                        }
                      }
                      listwidget[i*5] = Center(child: Container(color: const Color.fromARGB(84, 33, 149, 243),width: 100,height: 30,child: Center(child: Text(ls[i].toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))))));
                      listwidget[(i*5)+2] = Center(child: Text(plusses != 0 ? '+ $plusses' : '0',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))));
                      listwidget[(i*5)+4] = Center(child: Text(minuses != 0 ? '- $minuses' : '0',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))));
                      
                    plusses = 0;
                    minuses = 0;
                  }
                 
                }
             }else{

             }
        }else{
            listwidget =  List<Widget>.generate(100,(counter) => Container(margin: EdgeInsets.zero,child: const Text('')));
        }
      }
    }
    List<Widget> lw =  List<Widget>.from(listwidget);
    return lw;
  }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Widget> twoNumbersManagerListWidget({required AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot}){
    
    List<dynamic> listwidget = List<Widget>.generate(100,(counter) => const Text(''));
    int plusses = 0;
    int minuses = 0;
    for (var doc in snapshot.data!.docs) {
      // if(!snapshot.data!.docs.any((doc) => doc.id == widget.gameid)){
      //         Navigator.push(context,MaterialPageRoute(builder: (context) =>MyHomePage(name: widget.name) ));
      //}
      if(doc.id == widget.gameid){
       
        if(doc.data()['player2guessnumbers'] != null){
             List<String> ls = List<String>.from(doc.data()['player2guessnumbers']);
             String opponentnumber = doc.data()['player1number'].toString();
            //  if(opponentnumber == null){
            //    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>MyHomePage(name: widget.name) ));
            //  }
             if(ls != null){
                for (var i = 0; i < ls.length; i++) {
                  if(ls[i] != ''){
                      if(ls[i].split('')[0] == opponentnumber.split('')[0] ){plusses++;}
                      if(ls[i].split('')[1] == opponentnumber.split('')[1] ){plusses++;}
                      if(ls[i].split('')[2] == opponentnumber.split('')[2] ){plusses++;}
                      if(ls[i].split('')[3] == opponentnumber.split('')[3] ){plusses++;} 
                      //////////////////////////////////////////////////////////////////////////
                    
                      for (var k = 0; k < ls[i].split('').length; k++) {
                        for (var j = 0; j < opponentnumber.split('').length; j++) {
                          if(k != j){
                             if(ls[i].split('')[k] == opponentnumber.split('')[j] ){minuses++;}
                          }
                        }
                      }
                      listwidget[i*5] = Center(child: Container(color: const Color.fromARGB(84, 33, 149, 243),width: 100,height: 30,child: Center(child: Text(ls[i].toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))))));
                      listwidget[(i*5)+2] = Center(child: Text(plusses != 0 ? '+ $plusses' : '0',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))));
                      listwidget[(i*5)+4] = Center(child: Text(minuses != 0 ? '- $minuses' : '0',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 0, 0, 0))));
                      
                                      
                   plusses = 0;
                   minuses = 0;
                   
                  }
                  
                }
             }else{

             }
        }else{
            listwidget =  List<Widget>.generate(100,(counter) => const Text(''));
        }
      }
    }
    List<Widget> lw =  List<Widget>.from(listwidget);
    return lw;
  }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
   AlertDialog changeNumber(){return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 68, 71, 75),
        content: SizedBox(
          height: 100,
          width: 400,
          child: Card(
                  //margin: EdgeInsets.symmetric(horizontal: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side:  const BorderSide(color: Color.fromARGB(255, 0, 0, 0),width: 1),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  decoration: const InputDecoration(
                        border: InputBorder.none
                      ),
                      textAlign: TextAlign.center,
                      cursorColor: const Color.fromARGB(255, 119, 56, 33),
                      style: GoogleFonts.pacifico(
                        color: Colors.brown,fontSize: 32,fontWeight: FontWeight.bold,letterSpacing: 4,decoration: TextDecoration.none),
                      onChanged: (v)=>setState(() {
                        guessnumberchanging = v;
                      }),

                )
              ),
                  ),
                ),
        ),
        actions: [
           Center(
             child: Column(
               children: [
                 const SizedBox(height: 1,),
                 Center(child: Text(thenumberchangingerror,style:GoogleFonts.pacifico(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 15,decoration: TextDecoration.none,letterSpacing: 4),),),
                 const SizedBox(height: 1,),
                 TextButton(
                   
                   style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                        backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(125, 255, 94, 0)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48.0),
                            side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          )
                        )
                       ), 
                      child: Container(width: 100,margin: const EdgeInsets.all(30),child: Center(child: Text('CHANGE',style: GoogleFonts.pacifico(fontSize: 18,color: Colors.white),))),
       
                   onPressed: () {
                      if(isInteger(guessnumberchanging)){
                                print('a');
                                if((int.parse(guessnumberchanging.toString())*0.001).toInt() >= 1 && (int.parse(guessnumberchanging.toString())*0.001).toInt() < 10){
                                  print('b');
                                  setState(() {
                                  thenumberchangingerror = '';
                                  });
                                  String number = guessnumberchanging.toString();
                                  print(number.split('')[0]);
                                  if(number.split('')[0] != number.split('')[1] &&
                                     number.split('')[0] != number.split('')[2] &&
                                     number.split('')[0] != number.split('')[3] &&
                                     number.split('')[1] != number.split('')[2] &&
                                     number.split('')[1] != number.split('')[3] &&
                                     number.split('')[2] != number.split('')[3]
                                  ){
                                         setState(() {
                                           numberChanged = true;  
                                           
                                         });
                                         setState(() {
                                           theguess = number;  
                                         });
                                         print(theguess);
                                        widget.me == 'player1' ? 
                                            rooms.doc(widget.gameid).update({'player1number' : int.parse(number)}) 
                                            : 
                                            rooms.doc(widget.gameid).update({'player2number' : int.parse(number)});
                                        Navigator.of(context).pop();
                                  }
                                  else{
                                    setState(() {
                                  thenumberchangingerror = 'Enter a 4 different digit numbers';
                                });
                                  }
                                }
                                else{
                                print('d');
                                setState(() {
                                  thenumberchangingerror = 'Enter a 4 digit numbers';
                                });
                              }
                              }
                              else{
                                print('c');
                                setState(() {
                                  thenumberchangingerror = 'Enter a 4 digit numbers';
                                });
                              }
                    
                   }
                 ),
               ],
             ),
           )
        ],
      );  
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String p1 = '';
    String p2 = '';
    

   
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: rooms.snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
                print('introRM snapshot yok');
                return const Scaffold(body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: Text('Rooms preparing to start..',style: TextStyle(fontSize: 30,letterSpacing: 5),),),
                  Center(child: CircularProgressIndicator(color: Colors.green,strokeWidth: 10,)),
                ],
                      ));
            }
        rooms.get().then((value) { 
          if(value.docs.every((element) => element.id != widget.gameid)){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MenuPage(name: widget.name,)), );
        }
        });
        
        rooms.doc(widget.gameid).get().then((v) => p1 =  v.data()!['player1']);
        rooms.doc(widget.gameid).get().then((v) => p2 =  v.data()!['player2']);
        String player1number = '';
        String player2number = '';
        
          for (var doc in snapshot.data!.docs) {
                                   if(doc.id == widget.gameid){
                                       player1number =  doc.data()['player1number'].toString();
                                   } 
          }
           for (var doc in snapshot.data!.docs) {
                                   if(doc.id == widget.gameid){
                                       player2number =  doc.data()['player2number'].toString();
                                   } 
          }
          
        return Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(134, 255, 191, 0),
                title: Row(
                  children: [
                    const Expanded(flex: 100,child: Text(''),),
                    Text('YONKETA',style: GoogleFonts.pacifico(),),
                    const Expanded(flex: 90,child: Text(''),),
                    SizedBox(width: width*0.1,child: Center(child: Text(_start.toString(),style: GoogleFonts.pacifico(color: Colors.yellow,fontSize: 30)))),
                  ],
                ),
          ),
          body: SingleChildScrollView(
            child: Center(child: Container(
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
                  Center(child: Text(widget.gameid,style: const TextStyle(color: Colors.red),)),
                  
                  numberEntered ? 
                  
                   StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                     stream: rooms.snapshots(),
                     builder: (context, snapshot) {
                       if(!snapshot.hasData) return const CircularProgressIndicator(strokeWidth: 10,color: Colors.green,);
                        
                        if (snapshot.data!.docs.any((element) => element.id == widget.gameid && element.data()['gamefinished'] == true)) {
                          String whowon = '';
                          String guessnum = '';
                          for (var doc in snapshot.data!.docs) {   
                              if (doc.id == widget.gameid ) {
                                 whowon = doc.data()['whowon'].toString();
                                 if(whowon == doc.data()['player1']){
                                    guessnum = doc.data()['player1number'].toString();
                                 }
                                 else if(whowon == doc.data()['player2']){
                                    guessnum = doc.data()['player2number'].toString();
                                 }
                              }
                              
                          }
                          return Center(child: winAlert(whowon,guessnum,rooms));
                        } else {
                          return SingleChildScrollView(
                         child: Column(
                           children: [
                            
                             Row(children: [
                               const SizedBox(width: 10,),
                               SizedBox(width: width*0.44,child: Center(child: Text(p1,style: GoogleFonts.pacifico(fontSize: 16,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 0, 0, 0))))),
                               const SizedBox(width: 20,),
                               SizedBox(width: width*0.44,child: Center(child: Text(p2,style: GoogleFonts.pacifico(fontSize: 16,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 0, 0, 0))))),
                               const SizedBox(width: 10,),
                             ],),
                             const SizedBox(height: 0.5,),
                             Row(
                               children: [
                                 const SizedBox(width: 5,),
                                 Container(
                                   
                                   decoration: BoxDecoration(
                                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
                                     border: Border.all(color: const Color.fromARGB(255, 0, 94, 255)),
                                     color: const Color.fromARGB(24, 0, 150, 135),
                                   ),
                                   //
                                   width: width*0.48,
                                   height: height*0.05,
                                   child: Center(
                                     child: Text(
                                       widget.me == 'player1' ? 
                                           player1number.toString()
                                       : 
                                       '',
                                       style: GoogleFonts.pacifico(fontSize: 20,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 0, 0, 0))),
                                   ),
                                 ),
                                 const SizedBox(width: 6,),
                                 Container(
                                   decoration: BoxDecoration(
                                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
                                     border: Border.all(color: const Color.fromARGB(255, 90, 71, 15)),
                                     color: const Color.fromARGB(26, 90, 71, 15),
                                   ),
                                  // color: Colors.teal,
                                   height: height*0.05,
                                   width: width*0.48,
                                   child: Center(child: Text(widget.me == 'player2' ? player2number.toString() : '',style: GoogleFonts.pacifico(fontSize: 20,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 0, 0, 0))),),
                                 ),
                                 //SizedBox(width: 10,),
                               ],
                             ),
                             const SizedBox(height:1,),
                             Row(
                               children: [
                                 const SizedBox(width: 5,),
                                 Container(
                                   
                                   decoration: BoxDecoration(
                                     border: Border.all(color: const Color.fromARGB(255, 0, 94, 255)),
                                     color: const Color.fromARGB(24, 0, 150, 135),
                                   ),
                                   //
                                   width: width*0.48,
                                   height: height*0.30,
                                   child: GridView.count(
                                     
                                     shrinkWrap: true,
                                     padding: EdgeInsets.zero,
                                     crossAxisSpacing: 0,
                                     mainAxisSpacing: 0,
                                     crossAxisCount: 5,
                                     children: oneNumbersManagerListWidget(snapshot:snapshot,),
                                     //
                                   ),
                                 ),
                                 const SizedBox(width: 6,),
                                 Container(
                                   decoration: BoxDecoration(
                                     border: Border.all(color: const Color.fromARGB(255, 90, 71, 15)),
                                     color: const Color.fromARGB(26, 90, 71, 15),
                                   ),
                                   height: height*0.30,
                                   width: width*0.48,
                                   child: GridView.count(
                                     shrinkWrap: true,
                                     padding: EdgeInsets.zero,
                                     crossAxisSpacing: 0,
                                     mainAxisSpacing: 0,
                                     crossAxisCount: 5,
                                     children: twoNumbersManagerListWidget(snapshot:snapshot,),
                                   ),
                                 ),
                                 
                               
                               ],
                             ),
                             const SizedBox(height: 10,),
                              Container(
                               
                               margin: const EdgeInsets.fromLTRB(0,1,0,1),
                               child: Card(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(40.0),
                                   side: const BorderSide(width: 2,color: Color.fromARGB(255, 13, 54, 29)),
                                           
                                 ),
                                 child: Center(
                                   child: Row(
                                   children: [
                                               SizedBox(
                                                 width: width*0.6,
                                                 child: TextField(
                                                     controller:_controller,
                                                     decoration: const InputDecoration(
                                                       border: InputBorder.none
                                                     ),
                                                     textAlign: TextAlign.center,
                                                     cursorColor: const Color.fromARGB(255, 119, 56, 33),
                                                     style: GoogleFonts.pacifico(
                                                       color: Colors.brown,fontSize: 32,fontWeight: FontWeight.bold,letterSpacing: 4,decoration: TextDecoration.none),
                                                     onChanged: (v)=>setState(() {
                                                       theguess = v;
                                                     }),
                                                   ),
                                                 ),
                                     Container(
                                       height: 80,
                                       width: width*0.377,
                                       decoration: BoxDecoration(
                                         color: _start == 0 ? const Color.fromARGB(158, 47, 255, 0) : Colors.grey,
                                         border: Border.all(
                                            width: 3,
                                            color: const Color.fromARGB(255, 175, 76, 76),
                                            style: BorderStyle.solid,
                                          ),borderRadius: const BorderRadius.only(topRight: Radius.circular(40),bottomRight: Radius.circular(40))
                                       ),
                                       child: TextButton(
                                            style: ButtonStyle(
                                                 shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                                                 backgroundColor:MaterialStateProperty.all<Color>(Colors.transparent),
                                                ),
                                         onPressed:  _start == 0 && 
                                            snapshot.data!.docs.any((doc)=>
                                                 doc.id == widget.gameid  && doc.data()['player1number'] != null && doc.data()['player2number'] != null ?  true :  false)
                                           ?  
                                          () async{
                                           if(isInteger(theguess)){
                                                      if((int.parse(theguess.toString())*0.001).toInt() >= 1 && (int.parse(theguess.toString())*0.001).toInt() < 10){
                                                        setState(() {
                                                        thepopupnumbererror = '';
                                                        });
                                                        String guessnumber = theguess.toString();
                                                        if(guessnumber.split('')[0] != guessnumber.split('')[1] &&
                                                           guessnumber.split('')[0] != guessnumber.split('')[2] &&
                                                           guessnumber.split('')[0] != guessnumber.split('')[3] &&
                                                           guessnumber.split('')[1] != guessnumber.split('')[2] &&
                                                           guessnumber.split('')[1] != guessnumber.split('')[3] &&
                                                           guessnumber.split('')[2] != guessnumber.split('')[3]
                                                        ){
                                                              if(widget.me == 'player1'){
                                                                  for (var doc in snapshot.data!.docs) {
                                                                    
                                                                    if (doc.id == widget.gameid ) {
                                                                      String p2n = doc.data()['player2number'].toString();
                                                                       String p1name = doc.data()['player1'].toString();
                                                                       
                                                                     if(theguess == p2n){ 
                                                                       print('AAAAAAAAA');
                                                                        setState(() {
                                                                          player1won = true;
                                                                          player2won = false;
                                                                          gamefinished = true;
                                                                        });
                                                                        await rooms.doc(widget.gameid).update({'gamefinished':true});
                                                                        await rooms.doc(widget.gameid).update({'whowon':p1name});
                                                                       // showDialog(
                                                                       //   context: context,
                                                                       //    builder: (BuildContext context) {
                                                                       //      
                                                                       //      return Container(
                                                                       //        decoration: const BoxDecoration(
                                                                       //            image: DecorationImage(
                                                                       //              colorFilter: ColorFilter.mode(
                                                                       //                Colors.white,
                                                                       //                BlendMode.softLight,
                                                                       //              ),
                                                                       //              image: AssetImage("assets/paper.png"),
                                                                       //              repeat: ImageRepeat.repeat,
                                                                       //              fit: BoxFit.cover,
                                                                       //            ),
                                                                       //            ),
                                                                       //        child: winAlert(p1name,theguess,rooms));
                                                                       //    },
                                                                       // );
                                                                      }
                                                                  // else if(doc.data()['player2guessnumbers'].any<String>((n)=>n.toString() == p1n)){
                                                                  //   print('BBBBBBBB');
                                                                  //     setState(() {
                                                                  //     player1won = false;
                                                                  //     player2won = true;
                                                                  //     gamefinished = true;
                                                                  //   });
                                                                  //   await rooms.doc(widget.gameid).update({'gamefinished':true});
                                                                  //   showDialog(
                                                                  //     context: context,
                                                                  //      builder: (BuildContext context) {
                                                                  //        
                                                                  //        return Container(
                                                                  //          decoration: const BoxDecoration(
                                                                  //              image: DecorationImage(
                                                                  //                colorFilter: ColorFilter.mode(
                                                                  //                  Colors.white,
                                                                  //                  BlendMode.softLight,
                                                                  //                ),
                                                                  //                image: AssetImage("assets/paper.png"),
                                                                  //                repeat: ImageRepeat.repeat,
                                                                  //                fit: BoxFit.cover,
                                                                  //              ),
                                                                  //              ),
                                                                  //          child: winAlert(p2name,theguess,rooms));
                                                                  //      },
                                                                  //   );
                                                                  // }
                                                                      if(doc.data()['player1guessnumbers'] == null){
                                                                        print('a');
                                                                        List<String> list1 = [];
                                                                        list1.add(guessnumber);
                                                                        rooms.doc(widget.gameid).update({'player1guessnumbers': list1});
                                                                      }
                                                                      else{
                                                                        print('b');
                                                                        List<String> list1 = List<String>.from(doc.data()['player1guessnumbers']);
                                                                        list1.removeWhere((e) => e == '');
                                                                        list1.add(guessnumber);
                                                                        rooms.doc(widget.gameid).update({'player1guessnumbers': list1});
                                                                      }
                                                                    }
                                                                  }
                                                              }else if(widget.me == 'player2'){
                                                               
                                                                 for (var doc in snapshot.data!.docs) { 
                                                                   
                                                                    if (doc.id == widget.gameid ) {
                                                                       String p1n = doc.data()['player1number'].toString();
                                                                        String p2name = doc.data()['player2'].toString();
                                                                    if(theguess == p1n){ 
                                                                      print('CCCCCCCCCC');
                                                                       setState(() {
                                                                               player2won = true;
                                                                               player1won = false;
                                                                               gamefinished = true;
                                                                             });
                                                                        await rooms.doc(widget.gameid).update({'gamefinished':true});
                                                                        await rooms.doc(widget.gameid).update({'whowon':p2name});
                                                                       // showDialog(
                                                                       //   context: context,
                                                                       //    builder: (BuildContext context) {
                                                                       //      
                                                                       //      return winAlert(p2name,theguess,rooms);
                                                                       //    },
                                                                       // );
                                                                    }
                                                                 //else if(doc.data()['player1guessnumbers'].any<String>((n)=>n.toString() == p2n)){
                                                                 //  print('DDDDDDDD');
                                                                 //      setState(() {
                                                                 //      player1won = true;
                                                                 //      player2won = false;
                                                                 //      gamefinished = true;
                                                                 //    });
                                                                 //    await rooms.doc(widget.gameid).update({'gamefinished':true});
                                                                 //    showDialog(
                                                                 //      context: context,
                                                                 //       builder: (BuildContext context) {
                                                                 //         
                                                                 //         return Container(
                                                                 //           decoration: const BoxDecoration(
                                                                 //               image: DecorationImage(
                                                                 //                 colorFilter: ColorFilter.mode(
                                                                 //                   Colors.white,
                                                                 //                   BlendMode.softLight,
                                                                 //                 ),
                                                                 //                 image: AssetImage("assets/paper.png"),
                                                                 //                 repeat: ImageRepeat.repeat,
                                                                 //                 fit: BoxFit.cover,
                                                                 //               ),
                                                                 //               ),
                                                                 //           child: winAlert(p1name,theguess,rooms));
                                                                 //       },
                                                                 //    );
                                                                 //  }
                                                                      if(doc.data()['player2guessnumbers'] == null){
                                                                        print('a');
                                                                        List<String> list2 = [];
                                                                        list2.add(guessnumber);
                                                                        rooms.doc(widget.gameid).update({'player2guessnumbers': list2});
                                                                      }
                                                                      else{
                                                                        print('b');
                                                                        List<String> list2 = List<String>.from(doc.data()['player2guessnumbers']);
                                                                        list2.removeWhere((e) => e == '');
                                                                        list2.add(guessnumber);
                                                                        rooms.doc(widget.gameid).update({'player2guessnumbers': list2});
                                                                      }
                                                                    }
                                                                 }
                                                              }
                                                               setState(() {
                                                               _start = 10;
                                                               _controller.clear();
                                                               });
                                                               startTimer();
                                                        }
                                                        else{
                                                          setState(() {
                                                        thepopupnumbererror = 'Enter a 4 different digit number';
                                                          });
                                                        }
                                                       
                                                      }
                                                      else{
                                                      print('d');
                                                      setState(() {
                                                        thepopupnumbererror = 'Enter a 4 digit number';
                                                      });
                                                      }
                                                      
                                               }
                                               else{
                                                 print('c');
                                                 setState(() {
                                                   thepopupnumbererror = 'Enter a 4 digit number';
                                                 });
                                               }
                                            }
                                            :
                                            null, 
                                               child: Container(
                                                 decoration: BoxDecoration(
                                                   border: Border.all(
                                                    width: 3,
                                                    color: Colors.brown,
                                                    style: BorderStyle.solid,
                                                   ),
                                                   borderRadius: const BorderRadius.only(
                                                     topRight: Radius.circular(40),
                                                     bottomRight: Radius.circular(40)
                                                   )
                                                 ),
                                                 child: Center(child: Text('OK',style: GoogleFonts.pacifico(fontSize: 28,color: Colors.brown),)))
                                          
                                       ),
                                     ),
                                    ],),
                               )
                               ),
                             ),
                             SizedBox(height: 20,child: Center(child: Text(thepopupnumbererror,style: GoogleFonts.pacifico(fontSize: 13,fontWeight: FontWeight.bold,color:const Color.fromARGB(255, 255, 0, 0))))),
                             const SizedBox(height: 60,),
                             Row(
                               
                               children: [
                                 const Expanded(flex: 1,child: Text(''),),
                                 Container(
                                           height: 70,
                                           width: width*0.29,
                                           decoration: BoxDecoration(
                                             color: shuffled ? Colors.grey : Colors.green,
                                             border: Border.all(
                                                width: 3,
                                                color: const Color.fromARGB(255, 71, 70, 70),
                                                style: BorderStyle.solid,
                                              ),borderRadius: const BorderRadius.all(Radius.circular(40))
                                           ),
                                           child: TextButton(
                                                style: ButtonStyle(
                                                     shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                                                     backgroundColor:MaterialStateProperty.all<Color>(Colors.transparent),
                                                    ),
                                           onPressed: 
                                            shuffled ? null 
                                            : 
                                            (){
                                             
                                             String pnum = '';
                                             widget.me == 'player1' ? snapshot.data!.docs.forEach((doc) {  
                                               if(widget.gameid == doc.id){
                                                   
                                                   pnum = doc.data()['player1number'].toString();
                                                }
                                                }) 
                                                : snapshot.data!.docs.forEach((doc) {
                                                  if(widget.gameid == doc.id){
                                                    pnum = doc.data()['player2number'].toString();
                                                  }
                                                  });
                                             
                                             List<String> result = [pnum.toString().split('')[3],
                                                                    pnum.toString().split('')[1],
                                                                    pnum.toString().split('')[2],
                                                                    pnum.toString().split('')[0]
                                                                   ];
                                            
                                             pnum = ((int.parse(result[0])*1000)+(int.parse(result[1])*100)+(int.parse(result[2])*10)+int.parse(result[3])).toString();
                                             widget.me == 'player1' ? rooms.doc(widget.gameid).update({'player1number' : int.parse(pnum)})
                                                                    : rooms.doc(widget.gameid).update({'player2number' : int.parse(pnum)});
                                             setState(() {
                                               shuffled = true;
                                               thenumber = pnum;
                                             });
                                             
                                           }, 
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       border: Border.all(
                                                        width: 3,
                                                        color: const Color.fromARGB(255, 255, 255, 255),
                                                        style: BorderStyle.solid,
                                                       ),
                                                       borderRadius: const BorderRadius.all(Radius.circular(40))
                                                     ),
                                                     child: Center(child: Text('SHUFFLE',style: GoogleFonts.pacifico(fontSize: 14,color: Colors.black),))),          
                                           )
                                      ),
                                      const SizedBox(width : 10),
                                      Container(
                                           height: 70,
                                           width: width*0.29,
                                           decoration: BoxDecoration(
                                             color: numberChanged ? Colors.grey : Colors.green,
                                             border: Border.all(
                                                width: 3,
                                                color: const Color.fromARGB(255, 71, 70, 70),
                                                style: BorderStyle.solid,
                                              ),borderRadius: const BorderRadius.all(Radius.circular(40))
                                           ),
                                           child: TextButton(
                                                style: ButtonStyle(
                                                     shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                                                     backgroundColor:MaterialStateProperty.all<Color>(Colors.transparent),
                                                    ),
                                           onPressed: 
                                                !numberChanged ?  
                                             (){
                                                showDialog(
                                                        context: context,
                                                         builder: (BuildContext context) {
                                                           return changeNumber();
                                                         },
                                                );
                                             
                                           }
                                           :  null, 
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       border: Border.all(
                                                        width: 3,
                                                        color: const Color.fromARGB(255, 255, 255, 255),
                                                        style: BorderStyle.solid,
                                                       ),
                                                       borderRadius: const BorderRadius.all(Radius.circular(40))
                                                     ),
                                                     child: Center(child: Text('CHANGE',style: GoogleFonts.pacifico(fontSize: 14,color: Colors.black),)))
                                                     
                                           )
                                      ),
                                      const SizedBox(width : 10),
                                      Container(
                                           height: 70,
                                           width: width*0.29,
                                           decoration: BoxDecoration(
                                             color: !fasted && _start > 0  ? Colors.green : Colors.grey,
                                             border: Border.all(
                                                width: 3,
                                                color: const Color.fromARGB(255, 71, 70, 70),
                                                style: BorderStyle.solid,
                                              ),borderRadius: const BorderRadius.all(Radius.circular(40))
                                           ),
                                           child: TextButton(
                                                style: ButtonStyle(
                                                     shadowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(97, 255, 255, 255)),
                                                     backgroundColor:MaterialStateProperty.all<Color>(Colors.transparent),
                                                    ),
                                           onPressed: 
                                             !fasted && _start > 0 ?
                                             (){
                                             setState(() {
                                               fasted = true;
                                               _start = _start - 1;
                                              
                                             });
                                             startTimer();
                                           }
                                           : null, 
                                                   child: Container(
                                                     decoration: BoxDecoration(
                                                       border: Border.all(
                                                        width: 3,
                                                        color: const Color.fromARGB(255, 255, 255, 255),
                                                        style: BorderStyle.solid,
                                                       ),
                                                       borderRadius: const BorderRadius.all(Radius.circular(40))
                                                     ),
                                                     child: Center(child: Text('FAST',style: GoogleFonts.pacifico(fontSize: 14,color: Colors.black),)))          
                                           )
                                      ),
                                      const Expanded(flex: 1,child: Text(''),),
                               ],
                             ),
                             
                           ],   
                         ),
                       );
                        }
                     }
                   )
                  : //IF GAME STARTS WITH 2 PLAYERS
                  (
                  snapshot.data!.docs.any((doc)=>doc.id == widget.gameid && doc.data()['player2'] != '')  ? 
                    
                  Container(
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
                        SizedBox(height: height*0.4,),
                        ElevatedButton(
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all<Color>(Colors.white38),
                          backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(156, 255, 136, 0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                            )
                          )
                         ), 
                        child: Container(margin: const EdgeInsets.all(15),child: Text('Enter Your Number',style: GoogleFonts.pacifico(fontSize: 24,color:Colors.black),)),
                        onPressed: (){
                           for (var doc in snapshot.data!.docs) {doc.data()['player1'] != '' && doc.data()['player2'] != '' ? 
                           widget.me == 'player1' ? 
                              rooms.doc(doc.id).update({'player1number': ''}) 
                              :
                              rooms.doc(doc.id).update({'player2number': ''}) 
                           : true;}
                          setState(() {
                            thenumbererror = '';
                          });
                          showBottomSheet(rooms:rooms,snapshot: snapshot);
                          
                        }),
                      ],
                    ),
                  )
                  
                  :
                  
                  Container(
                    height: height*0.9,
                     width: width,
              decoration: const BoxDecoration(
               ),
                    child: Column(
                      children: [
                        const Expanded(flex: 3,child: Text(''),),
                        Expanded(flex: 5,child: Text('Waiting a player',style: GoogleFonts.pacifico(fontSize: 30,fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 76, 70, 70))),),
                        const Expanded(flex: 2,child: Text(''),),
                        SizedBox(
                          height: 100,
                          child: ElevatedButton(
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
                             await Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MenuPage(name : widget.name)), );
                            },
                           child:Padding(
                             padding: const EdgeInsets.all(15.0),
                             child: Text('BACK TO MENU',style: GoogleFonts.pacifico(fontSize: 30,color: Colors.black)),
                           ),
                           ),
                        ),
                        const Expanded(flex: 1,child: Text(''),),
                      ],
                    ),
                  )
                  ),
                  
                ],
              ),
            )),
          ),
        );
      }
    );
  }
}