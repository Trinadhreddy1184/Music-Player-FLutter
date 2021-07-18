import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/scheduler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:LocalMusic/MyStatefulWidget.dart';
import 'audiomanager.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: camel_case_types


class playingscreen extends StatefulWidget {
  var nex;
  int index;
  var mp;
  List<SongInfo> songlist;
  var current;
  playingscreen({required this.songlist,required this.index,required this.nex}){
      songlist=this.songlist;
      index=this.index;
      nex=this.nex;

  }
  @override
  playingscreenState createState() => playingscreenState(songlist,index,nex);
}

class playingscreenState extends State<playingscreen> {
  var isPlaying;
  var index;
  // ignore: top_level_instance_method
  var nex;
  var audioManagerInstance =  audiomanager().Instance;
  var songlist;
  var song;
  var img;
  var color;
  List  pallettecolor=[];
  List oppcolor=[];
  var pal;
  var opp;
  var rand=Random();
  late bool shuff;
  late bool loop;
  final prefs = SharedPreferences.getInstance();
  var myclass;
  List randsongs=[];
  playingscreenState(List<SongInfo> songlist,int index,bool nex) {
    this.songlist = songlist;
    this.index=index;
    this.nex=nex;

  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState ();
    getsharedvalues();
    randsongs=[];
   //
    index=this.index;
    if(nex){
      next();
    }
    setupAudio();
  }

  getsharedvalues() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loop = prefs.getBool('loop')?? false;
      shuff=prefs.getBool('shuff')?? false;
    });
  }
  setsharedvalues()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('loop',loop);
      prefs.setBool('shuff',shuff);
    });
  }

  Map colormap={};
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //audioManagerInstance.stop();

  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    setsharedvalues();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    song=songlist[index];
    pal=Provider.of<audiomanager>(context).pallette;
    opp=Provider.of<audiomanager>(context).opp;
    pal.entries.forEach((e) {pallettecolor.add(e.value);});
    opp.entries.forEach((e) {oppcolor.add(e.value);});
    Provider.of<audiomanager>(context).setcurrentsong(index);
    img=Provider.of<audiomanager>(context).mp[song.title];
    if(Provider.of<audiomanager>(context).stats=='play'){
    audioManagerInstance
        .start("file://${song.filePath}", song.title,
        desc: song.displayName,
        auto:false,
        cover: 'images/playstore.png')
        .then((err) {
      print(err);
    });}
    return SafeArea(
      child: SwipeDetector(

      //background: MyStatefulwidget(songList: songlist,),

      //direction: DismissDirection.down,
      onSwipeDown:(){

          Navigator.pop(context, index);
        //});
      },
      //key: Key(index.toString()),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          color: pallettecolor.isEmpty ?(Colors.grey.shade200): pal[song.title].color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        iconSize: 25, color: oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.black, onPressed: () {
                        SchedulerBinding.instance!.addPostFrameCallback((_) async {
                            Navigator.pop(context, index);
                          });
                      }, icon: Icon(Icons.keyboard_arrow_down_rounded,),),
                      Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [ Icon(Icons.view_module_rounded, size: 25,
                            color:oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color :Colors.white :Colors.black,),
                          ]),)
                      //Expanded(child: Center(child: )),
                    ],
                  ),
                ),
              ),
              Expanded(child: Stack(
                  children: [ Opacity(
                    opacity: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: img,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(
                            35), topRight: Radius.circular(35)),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                    Padding(
                      padding: EdgeInsets.only(left:10,top:10),
                      child: Text(
                        song.title, textAlign: TextAlign.left,
                        style: GoogleFonts.michroma(fontSize: 30,color:  oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title]) ? opp[song.title].color:Colors.white :Colors.black,
                          fontWeight: FontWeight.bold,),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 15,bottom: 15),child: IconButton(onPressed: (){
                                  if(shuff){
                                    shuff=false;
                                    setsharedvalues();
                                  }
                                  else{
                                    shuff=true;
                                    setsharedvalues();
                                  }
                                },
                                    icon: (!shuff)?Icon(CupertinoIcons.shuffle,size:25,color: oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.white ,):CircleAvatar(backgroundColor: pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])?  pal[song.title].color :pal[song.title].color :Colors.black,child: Icon(CupertinoIcons.shuffle_thick,size: 25,color:oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.white,)))),
                                Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15,bottom: 15),
                                          child: IconButton(onPressed: (){
                                            if(loop){
                                              loop=false;
                                              setsharedvalues();
                                            }
                                            else loop=true;
                                            setsharedvalues();

                                          }, icon:(!loop)?Icon(Icons.repeat_one_rounded,size: 25,color:  oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.white ,):CircleAvatar(backgroundColor:pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])?  pal[song.title].color :pal[song.title].color :Colors.black ,child: Icon(Icons.repeat_one,size: 25,color:  oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.white ,))),
                                        ),
                                    ]),)


                              ],
                            ),
                            bottomPanel(),
                          ],
                        ),
                      ],
                    ),
                  ]
              ),
              ),
            ],
          ),
        ),
      ),
      ),
    );

  }

  void setupAudio() {
    audioManagerInstance.onEvents((events, args){
      switch (events) {
        case AudioManagerEvents.stop:
          audiomanager.slider=audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          break;
        case AudioManagerEvents.start:
          audiomanager.slider =audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds ?? 0.0;
          break;
        case AudioManagerEvents.seekComplete:
          audiomanager.slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {
            //stat='play';
          });
          break;
        case AudioManagerEvents.timeupdate:
          audiomanager.slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          audioManagerInstance.updateLrc(args["position"].toString());
          setState(() {
            //stat='play';
          });
          break;
        case AudioManagerEvents.previous:
          Provider.of<audiomanager>(context,listen:false).updatestats('play');
          setState(() {
            if(!loop) {
              if (index > 0) {
                if (shuff) {
                  if (randsongs.length > 0) {
                    index = randsongs[randsongs.length - 1];
                    randsongs.removeLast();
                  }
                  else
                    index--;
                }
                else
                  index--;
                //Provider.of<audiomanager>(context).stat= 'play';
              }
              else {
                index = songlist.length - 1;
               // Provider.of<audiomanager>(context).stat= 'play';
              }
            }
            else{
             // Provider.of<audiomanager>(context,listen:false).updatestats('play');
            }
          });
          break;
        case AudioManagerEvents.next:
          next();
          break;
        case AudioManagerEvents.ended:
          next();
          break;
        default:
          break;
      }
    });
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color:oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title]) ?  opp[song.title].color :Colors.white:Colors.white,
                    ),
                    onPressed: () {
                      Provider.of<audiomanager>(context,listen:false).updatestats('play');
                        setState(() {
                          if (!loop) {
                            if (index > 0) {
                              if (shuff) {
                                if (randsongs.length > 0) {
                                  index = randsongs[randsongs.length - 1];
                                  randsongs.removeLast();
                                }
                                else
                                  index--;
                              }
                              else
                                index--;
                           //   Provider.of<audiomanager>(context).stat= 'play';
                            }
                            else {
                              index = songlist.length - 1;
                             // Provider.of<audiomanager>(context).stat= 'play';
                            }
                          }
                         // else Provider.of<audiomanager>(context,listen:false).updatestats('play');
                        }
                        );

                        },),
                  ),
              backgroundColor: pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])?  pal[song.title].color :pal[song.title].color :Colors.black,
            ),
            CircleAvatar(
              radius: 30,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    //print("asdfgh------------${audioManagerInstance.isPlaying}");
                    if(audioManagerInstance.isPlaying){
                      audioManagerInstance.toPause();

                    //setState(() {
                      Provider.of<audiomanager>(context,listen:false).updatestats('pause');
                   // });
                    }
                    else{
                      audioManagerInstance.playOrPause();

                      //setState(() {
                        Provider.of<audiomanager>(context,listen:false).updatestats('play');
                      //});
                    }
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    (Provider.of<audiomanager>(context).stats=='play')
                        ? Icons.pause
                        : Icons.play_arrow,
                    color:oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color:Colors.white :Colors.white ,
                  ),
                ),
              ),
            backgroundColor:pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])?pal[song.title].color :pal[song.title].color :Colors.black ,
            ),

            CircleAvatar(
              backgroundColor: pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? pal[song.title].color :pal[song.title].color :Colors.black,
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color :Colors.white:Colors.white,
                    ),
                    onPressed: () {
                      next();
                      },
              ),
            ),),
          ],
        ),
      ),
    ]);
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }
  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? pal[song.title].color :opp[song.title].color :Colors.black);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(audioManagerInstance.position),
          style: style,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? pal[song.title].color :Colors.black:Colors.black,
                  overlayColor: oppcolor.isNotEmpty ?(pal[song.title]!=opp[song.title])? opp[song.title].color :opp[song.title].color :Colors.black,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor:pallettecolor.isNotEmpty ?(pal[song.title]!=opp[song.title])?  pal[song.title].color :Colors.white:Colors.white,
                  inactiveTrackColor: oppcolor.isNotEmpty ? (pal[song.title]!=opp[song.title])?opp[song.title].color :opp[song.title].color :Colors.black,
                ),
                child: Slider(
                  value: audiomanager.slider ?? 0.0,
                  onChanged: (value) {
                    setState(() {
                      audiomanager.slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (audioManagerInstance.duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                          (audioManagerInstance.duration.inMilliseconds *
                              value).roundToDouble().round()
                              );
                      audioManagerInstance.seekTo(msec);
                    }
                  },
                )),
          ),
        ),
        Text(
          _formatDuration(audioManagerInstance.duration),
          style: style,
        ),
      ],
    );
  }
 void next(){
   Provider.of<audiomanager>(context,listen:false).updatestats('play');
    setState(() {
      if(!loop) {
        if (index < songlist.length - 1) {
          if (shuff) {
            index = rand.nextInt(songlist.length - 1);
            randsongs.add(index);
          }
          else
            index++;
          // Provider.of<audiomanager>(context).stat= 'play';
        }
        else {
          index = 0;
          //Provider.of<audiomanager>(context).stat= 'play';
        }
      }
      //else Provider.of<audiomanager>(context,listen:false).updatestats('play');
    });
  }

}

