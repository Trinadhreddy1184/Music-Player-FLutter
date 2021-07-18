import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:LocalMusic/new.dart';
import 'audiomanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:swipedetector/swipedetector.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:LocalMusic/playingscreen.dart';

// ignore: must_be_immutable
class MyStatefulwidget extends StatefulWidget {
  var songList;
  MyStatefulwidget({required this.songList});

  @override
  _MyStatefulwidgetState createState() => _MyStatefulwidgetState(this.songList);
}

class _MyStatefulwidgetState extends State<MyStatefulwidget> {
  var songList;
  var pal,opp;
  List  pallettecolor=[];
  List oppcolor=[];
  _MyStatefulwidgetState(this.songList){
    songList=this.songList;
  }

  var playclass;
  List images=[];
  var rand=Random();
  var audioManagerInstance;

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    audiomanager();
  }

  @override
  Widget build(BuildContext context) {

    audioManagerInstance=Provider.of<audiomanager>(context).Instance;
    // TODO: implement build
    pal=Provider.of<audiomanager>(context).pallette;
    opp=Provider.of<audiomanager>(context).opp;
    pal.entries.forEach((e) {pallettecolor.add(e.value);});
    opp.entries.forEach((e) {oppcolor.add(e.value);});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: (){
                Fluttertoast.showToast(
                    msg: 'Favorites will be implemented soon ',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black
                );
               // Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) { return MyApps(); }));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                //color: Colors.blue.shade100,
                height: 60,
                width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_rounded,color: Colors.red,size: 40,),
                    Text("Favorites",textAlign: TextAlign.center,style: GoogleFonts.courgette(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black),)
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 0,
            ),
            FlatButton(
              onPressed: (){
                Fluttertoast.showToast(
                    msg: 'Playlists will be implemented soon ',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                //color: Colors.blue.shade100,
                height: 60,
                width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.playlist_add,color: Colors.black,size: 40,),
                    Text("Playlists",textAlign: TextAlign.center,style: GoogleFonts.courgette(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black),)
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height:10,
        ),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular((30)),topRight: Radius.circular(30)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlatButton(
                onPressed: (){
                  bool nex=false;

                  Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) { return playingscreen(songlist:songList,index:rand.nextInt(songList.length-1),nex:nex);}));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10,top: 5),
                  child: Row(
                    children: [
                      Icon(Icons.shuffle_rounded,size: 20,color: Colors.black,),
                      Text("Shuffle",style: GoogleFonts.courgette(fontSize:15),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(color: Colors.transparent,child: IconButton(onPressed: (){}, icon: Icon(Icons.swap_vert_rounded,size: 20,color: Colors.black,),)),
                    Material(color:Colors.transparent,child:IconButton(onPressed: () {  }, icon:Icon(Icons.sort_rounded,size: 20,color: Colors.black,),),)
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular((0)),topRight: Radius.circular(0)),
              ),
              padding: EdgeInsets.all(8),
              // ignore: unnecessary_null_comparison
              child:(songList == null) ?
              Center(
                child: Card(
                  child: Text("No songs in your device!!"),
                ),
              ):
              ListView.builder(
                  padding: EdgeInsets.all(6),
                  itemBuilder: (BuildContext context, int index) {
                    Color normal=Colors.grey.shade100;
                    SongInfo song = songList[index];
                    //if(song.displayName.contains(".mp3")){
                    return GestureDetector(
                      onTap: () {
                        var nex= false;
                        Provider.of<audiomanager>(context,listen:false).updatestats('play');
                        Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) { return playingscreen(songlist:songList,index:index,nex: nex);}));
                      },
                      child: Card(
                        //color:(Provider.of<audiomanager>(context).currentsong!=null)?pallettecolor.isEmpty?normal:(Provider.of<audiomanager>(context).currentsong==song)?pal[songList[Provider.of<audiomanager>(context).currentsong].title].color:normal:normal,

                        elevation: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                              children:[
                                ClipRRect(
                                  child: FutureBuilder<Uint8List>(
                                      future: audioQuery.getArtwork(type: ResourceType.ALBUM, id: song.albumId),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData){
                                          return Container(
                                            height: 60.0,
                                            width: 60,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 20,
                                              ),
                                            ),
                                          );
                                        }
                                        else if (snapshot.connectionState==ConnectionState.done ){
                                          if(snapshot.data!.isEmpty){

                                            return Container(
                                              child:Image(
                                                height: 60,width: 60,
                                                fit: BoxFit.fill,
                                                image:AssetImage('images/playstore.png'),
                                              ),);
                                          }
                                          else{
                                            return Container(
                                              child:Image(
                                                height: 60,width: 60,
                                                fit: BoxFit.fill,
                                                image: MemoryImage(snapshot.data!),
                                              ),);
                                          }
                                        }
                                        else{
                                          return Container(
                                            height: 60.0,
                                            width: 60,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 20,
                                              ),
                                            ),);
                                        }
                                      }),
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                Expanded(child: Text(song.title,textAlign: TextAlign.center,style: GoogleFonts.sourceSerifPro(fontSize: 16,fontWeight: FontWeight.bold,),)),
                              ]
                          ),
                        ),
                      ),
                    );
                    //}
                    //else{
                    //return SizedBox(
                    //height: 0,
                    //);
                    //}
                  },
                  // separatorBuilder: (BuildContext context, int index) => const Divider() ,
                  itemCount:songList.length)
          ),
        ),
        (Provider.of<audiomanager>(context).currentsong!=null)?
        BottomSheet(builder: btbuilder, onClosing: () {  },):Container(),
      ],
    );
  }

  Widget btbuilder(BuildContext context) {

    return GestureDetector(
      onTap: (){
        bool nex=false;
        if(Provider.of<audiomanager>(context,listen: false).currentsong!=null)
          Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) { return playingscreen(songlist:songList,index:Provider.of<audiomanager>(context).currentsong,nex:nex);}));
      },
      child: Container(
        decoration: BoxDecoration(
          color:  (Provider.of<audiomanager>(context).currentsong!=null)?pallettecolor.isEmpty ?(Colors.grey.shade200): pal[songList[Provider.of<audiomanager>(context).currentsong].title].color:(Colors.grey.shade200),
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
        ),
        height: 60,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image(
                image: Provider.of<audiomanager>(context).currentsong==null ? AssetImage('images/playstore.png') :Provider.of<audiomanager>(context).mp[songList[Provider.of<audiomanager>(context).currentsong].title],
                height: 60,
                width:60,
              ),
            ),
            Align(alignment: Alignment.center,child: Container (width: 200,child: Text((Provider.of<audiomanager>(context).currentsong==null)? ' ':songList[Provider.of<audiomanager>(context).currentsong].title.toString(),textAlign: TextAlign.center,style: GoogleFonts.courgette(color:(Provider.of<audiomanager>(context).currentsong!=null)?oppcolor.isEmpty ?(Colors.black): opp[songList[Provider.of<audiomanager>(context).currentsong].title].color:(Colors.black),fontSize:16,fontWeight: FontWeight.bold,),))),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[ Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if(audioManagerInstance.isPlaying){
                            audioManagerInstance.playOrPause();
                            Provider.of<audiomanager>(context,listen:false).updatestats('pause');
                          }
                          else{
                            audioManagerInstance.playOrPause();
                            Provider.of<audiomanager>(context,listen:false).updatestats('play');
                            bool nex=false;
                            Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) { return playingscreen(songlist:songList,index:Provider.of<audiomanager>(context).currentsong,nex:nex);}));
                          }
                        },
                        padding: const EdgeInsets.only(top: 3.0),
                        icon: Icon(
                          (Provider.of<audiomanager>(context).stats=='play')
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                          color:(Provider.of<audiomanager>(context).currentsong!=null)?oppcolor.isEmpty ?(Colors.black): opp[songList[Provider.of<audiomanager>(context).currentsong].title].color:(Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,bottom: 10,left: 0),
                        child: IconButton( onPressed: () {
                          Provider.of<audiomanager>(context,listen:false).updatestats('play');
                          bool nex=true;
                          Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) { return playingscreen(songlist:songList,index:Provider.of<audiomanager>(context).currentsong,nex:nex);}));
                        }, icon: Icon(Icons.skip_next_rounded,size: 50,color:(Provider.of<audiomanager>(context).currentsong!=null)?oppcolor.isEmpty ?(Colors.black): opp[songList[Provider.of<audiomanager>(context).currentsong].title].color:(Colors.black),),),
                      ),
                    ],
                  ),]
              ),
            )
          ],
        ),
      ),
    );

  }

}







