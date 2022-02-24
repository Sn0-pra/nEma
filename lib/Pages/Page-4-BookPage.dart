import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class BookPage extends StatefulWidget {
  // const BookPage({ Key? key }) : super(key: key);
   final String link;
   final String title;
  BookPage(this.link,this.title);

  @override
  _BookPageState createState() => _BookPageState(link,title);
}

class _BookPageState extends State<BookPage> {

  final String link;
  final String title;
  _BookPageState(this.link,this.title);

 PDFDocument doc;
   

  var dio= Dio();
  @override
  Widget build(BuildContext context) {
    String data=link;
    viewNow() async {
      doc = await PDFDocument.fromURL(
          data);
      setState(() {

      });
    }
    loading(){
      viewNow();
      if(doc==null){
        return Center(
                    child: Text("Loading..."),
                  );
      }
    }
    return Scaffold(
      appBar: appbarforpdf(context),
      body: Container(
          child: doc==null?loading():PDFViewer(document: doc),
       
      )
    );
  }
   @override
 void initState() {
   super.initState();
   getPermission();
 }

  //get storage permission
  void getPermission() async {
    print("getPermission");
    await Permission.storage.request();
    setState(() {

        });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try{
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
          
    );
   
    //write in download folder
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  }
  catch (e){
    print("error is");
    print(e);
  }
  }
//progress bar
 showDownloadProgress(received, total){
  if (total != -1) {
  var percentage= ((received / total * 100).toStringAsFixed(0) + "%");
  print(percentage);
  }
}
appbarforpdf(context) {
 return AppBar(
    
            title: Text("nEma"),
            backgroundColor: Color(0xff5808e5),
            actions: <Widget>[
            Padding(
               padding: EdgeInsets.only(right: 20.0),
               child: GestureDetector(
                   onTap: () async{
                    String path =
              await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
              print(path);
              String fullPath = "$path/$title.pdf";
              
              gettt()async{
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                    content: Text('Downloading...'),
                  );
                  });
              await download2(dio, link, fullPath);
              Navigator.pop(context);
            } gettt();
            },
               child: Icon(
                   Icons.file_download,
                   size: 22.0,
                   ),
                 )
             ),
            ],
    
                iconTheme: IconThemeData(
                color: Colors.white,
                 ),
      );}
}