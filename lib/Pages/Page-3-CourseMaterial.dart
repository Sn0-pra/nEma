import 'package:flutter/material.dart';
import 'commonComponents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Page-3-CourseHome.dart';
import 'Page-4-videopage.dart';
import 'Page-4-BookPage.dart';

class CourseMaterial extends StatefulWidget {
  final DocumentSnapshot metadata;
  CourseMaterial({this.metadata});

  @override
  _CourseMaterialState createState() => _CourseMaterialState();
}

class _CourseMaterialState extends State<CourseMaterial> {
  Future videoData,bookdata;

  final databaseReference = FirebaseFirestore.instance;

  videolist() async {

    QuerySnapshot query = await databaseReference
        .collection("course")
        .doc(widget.metadata.id)
        .collection("videos")
        .get();
    return query.docs;
  }

  pdflist()async {

    QuerySnapshot query2 = await databaseReference
        .collection("course")
        .doc(widget.metadata.id)
        .collection("books")
        .get();
      return query2.docs;
  }

  void initState() {
    super.initState();
    videoData = videolist();
    print(videoData);
    bookdata = pdflist();
    print(bookdata);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appbar(context),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              banner("Dreams don't work unless you do. \n\n -Unknown",
                  "assets/dreams.jpg"),
              SizedBox(
                height: 20.0,
              ),
              heading("Topic"),
              courseBannerLayout(context, widget.metadata, false),
              SizedBox(
                height: 20.0,
              ),
              heading("Material"),
              
              urlCallMethod("Videos",videoData),
              urlCallMethod("Books", bookdata)
            ],
          )),
    );
  }
}

urlCallMethod(title, material) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: ExpansionTile(
      
      title: Text(title, style: TextStyle(fontSize: 18.0)),
      
      children: [

        Container(
          height: 250.0,
          child: FutureBuilder(
              
              future: material,
              
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  
                  return Center(
                    child: Text("Loading..."),
                  );
                
                } else {
                 
                  return ListView.builder(
                      
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        
                        return Padding(
                          
                          padding: const EdgeInsets.all(10.0),
                      
                          child: ListTile(
                            
                            title: Text(snapshot.data[index].data()["title"]),
                            
                            onTap: () {
                              var _showVideoPath =
                                  snapshot.data[index].data()["url"];
                              var _showBookPath =
                                  snapshot.data[index].data()["url"];
                              var _showBookTitle =
                                  snapshot.data[index].data()["title"];
                              
                              if(title == "Videos"){
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPage(_showVideoPath)));
                              }

                              if(title == "Books"){
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookPage(_showBookPath,_showBookTitle)));
                              }


                            },
                          ),
                        );
                        
                      });
                }
              }),
        )
      ],
    ),
  );
}
