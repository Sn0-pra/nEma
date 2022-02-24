import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'commonComponents.dart';

class VideoPage extends StatefulWidget {

  
 final String link;
  VideoPage(this.link);

  @override
  _VideoPageState createState() => _VideoPageState(link);
}

class _VideoPageState extends State<VideoPage> {

  bool play = false;
  String link;
  _VideoPageState(this.link);

  VideoPlayerController videoController;

  void _initPlayer(){
    videoController = VideoPlayerController.network(link);
    videoController.initialize();
    setState(() {
      
    });
  }

  void initState(){
    super.initState();
    _initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: appbar(context),
      
      body: Container(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children:[
           _playerWidget(),
            contactBox()
          ]
        ),

      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff5808e5),
        onPressed: (){
         
         if ( videoController.value.isPlaying ){
           
           setState((){
            play = false;
          });
           
           videoController.pause();
         
         } else{
           
           setState((){
            play = true;
          });
         
            videoController.play();
         
         }
        },
        child: play ? Icon(Icons.pause_circle_outline) : Icon(Icons.play_circle_outline)
    ));
  }
  
Widget _playerWidget(){
  return Container(
    height: 300.0,
    child: AspectRatio(
      aspectRatio: videoController.value.aspectRatio ,
      child: VideoPlayer(videoController),
    ),
  );
}

@override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

}



contactBox(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      heading("For any difficulties contact"),
      Container(
        margin: EdgeInsets.only(left:20.0),
        child: Text("E-mail: rapisalkar@gmail.com \nContact:9090909090\n",style: TextStyle(fontSize: 15.0),)
      ),
    ],
  );
}