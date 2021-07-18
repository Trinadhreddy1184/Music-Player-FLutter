import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class audiomanager extends ChangeNotifier{
  var prefs = SharedPreferences.getInstance();
  var audioManagerInstance = AudioManager.instance;
  audiomanager(){
    current();
  }
  var isPlaying;
  var stat='play';
  var currentsong;
  current()  async{
    final prefs = await SharedPreferences.getInstance();
    currentsong=prefs.getInt('currentsong') ?? null;
    notifyListeners();
  }

  String get stats{
    return stat;
  }


  setcurrentsong(index) async{
    currentsong=index;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentsong', currentsong);
    notifyListeners();
  }
  updatestats(value){
    stat=value;
    notifyListeners();
  }
  static var slider;
  get Instance{
    return audioManagerInstance;
  }
  var mp;
  var pallettecolor;
  var oppcolor;
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  maps(songList){
    mp={};
    pallettecolor={};
    oppcolor={};
    songList.forEach((song) async{
      //if(song.displayName.contains(".mp3")){
      var image;
      var data =await audioQuery.getArtwork(type: ResourceType.ALBUM, id: song.albumId);
      if(data.isEmpty){
        image=AssetImage('images/playstore.png');
      }
      else{
        image=MemoryImage(data);
      }
      mp[song.title]=image;
      final PaletteGenerator generator= await PaletteGenerator.fromImageProvider(image);
      pallettecolor[song.title]=generator.mutedColor!=null ? generator.mutedColor: PaletteColor(Colors.grey.shade200,2);
      oppcolor[song.title]=generator.dominantColor!=null ? generator.dominantColor : PaletteColor(Colors.white,2);
    }
    );


  }
  get pallette{
    return pallettecolor;
  }
  get opp{
    return oppcolor;
  }






}