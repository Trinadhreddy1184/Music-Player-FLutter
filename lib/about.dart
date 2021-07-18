import 'package:LocalMusic/main.dart';
import 'package:flutter/cupertino.dart';
import 'MyStatefulWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class about extends StatelessWidget {
  const about({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(

      backgroundColor: Colors.teal.shade200,
      body: Container(
        child:Center(
          child: Stack(
            children: [Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20,top:30)),
                    Row(
                      children: [
                        IconButton(icon: Icon(CupertinoIcons.back,color: Colors.white,),onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context){
                            return MyApp();
                          }));
                        },),
                        Text("Developed by",style: GoogleFonts.courgette(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 130, 0,0)),
                Expanded(
                    child:
                      Container(
                        decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
                        ),

                      ),

                  ),
              ],
            ),
              Opacity(
                opacity: 1,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 90)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            image:DecorationImage(
                              image: AssetImage('images/my.jpg'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(180)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text("Trinadhreddy Seelam",style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: 26,fontStyle: FontStyle.italic),),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('This is Trinadhreddy Seelam. I\'m currently Computer Science Engineering Student at RGUKT AP IIIT Ongole. I\'m currently looking for internship and job oppurtunities to advance my career.',
                          style: GoogleFonts.ubuntuMono(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Contact details',
                            style: GoogleFonts.roboto(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child:Column(
                            children: [

                              FlatButton(
                                onPressed: (){
                                  launch('https://www.google.com');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone),SizedBox(width: 5,),
                                  Text("+919182511969")
                                ],
                                ),
                              ),
                              FlatButton(
                                onPressed: (){

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.email_rounded),SizedBox(width: 5,),
                                    Text("trinadhreddysee@gmail.com",style: GoogleFonts.roboto(color: Colors.black),),
                                  ],
                                ),
                              ),
                            ],
                          ),)
                      ],
                    )
                  ],
                ),
              ),
            ]
          ),
        )
      ),
    ));
  }
}
