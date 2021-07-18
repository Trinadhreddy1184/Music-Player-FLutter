
import 'package:LocalMusic/about.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:LocalMusic/audiomanager.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'MyStatefulWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return audiomanager();
      },
      child: MaterialApp(
        title: "My Music",
        routes: <String, WidgetBuilder>{
          '/about': (BuildContext context) => about(),
        },
        theme: ThemeData(
        primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(
            color: Colors.black,
          )
        ),

        home: SafeArea(
          child: Scaffold(


            drawer: navdraw(),
            appBar: AppBar(
              centerTitle:true ,
              backgroundColor: Colors.white,
              toolbarHeight: 80,
              title: Text("My Music",style:GoogleFonts.cabinSketch(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 50,
                fontStyle: FontStyle.italic,
              ) ,),

            ),
            backgroundColor: Colors.grey.shade200,
            body: mystatefulwidget(),
          ),
        ),
      ),
    );
  }
}
class navdraw extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      elevation: 20,

      child: ListView(
        children: [
          DrawerHeader(child: Container(
            height: 50,
          ),),
          Divider(
            height: 1,
            thickness: 10,
          ),
          ListTile(
            onTap: (){
              Fluttertoast.showToast(
                  msg: 'Settings will be implemented soon ',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black
              );
            },
            leading: Icon(CupertinoIcons.settings_solid),
            title: Text("Settings"),
          ),
          SizedBox(

          ),
          Divider(
            height: 3,
            thickness: 10,
          ),
          ListTile(
            onTap: (){
              Navigator.pushReplacementNamed(context,'/about');
            },
            leading: Icon(Icons.person),
            title: Text("About",style: GoogleFonts.robotoMono(color: Colors.black,fontSize: 16),),

          )

        ],
      ),
    );
  }

}
class mystatefulwidget extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    // TODO: implement build
    return FutureBuilder(
      future: audioQuery.getSongs(sortType: SongSortType.RECENT_YEAR),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<SongInfo> songInfo = snapshot.data;
        List<SongInfo> songs=[];
        //print(songInfo);
        if ((snapshot.hasData)) {
          songInfo.forEach((song) { if (!song.title.isEmpty){
            songs.add(song);
          } });
          songInfo=songs;
          Provider.of<audiomanager>(context,listen:false).maps(songInfo);
          return MyStatefulwidget(songList: songInfo);
        } else {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Loading....",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        }
      },

    );
  }

}




