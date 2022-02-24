import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'commonComponents.dart';
import 'Page-3-CourseMaterial.dart';

class CourseHome extends StatefulWidget {

  final DocumentSnapshot metadata;
  CourseHome({this.metadata});

  @override
  _CourseHomeState createState() => _CourseHomeState();
}

class _CourseHomeState extends State<CourseHome> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(

        child: Scaffold(

          appBar: appbar(context),
          body: ListView(

            scrollDirection: Axis.vertical,
            children: [

              banner("The best way to predict future is to create it \n\n -Abraham Lincoln","assets/image2.jpg"),
              courseBannerLayout(context,widget.metadata,true),
              content(widget.metadata),
              SizedBox(height:40.0)
            ],

        )
          
        ),
    );
  }
}

content(metadata){

  Future<List<dynamic>> getsyllabus() async{

  List<String> syllabus = List.from(metadata['syllabus']);
  return syllabus;
}
  
  return Container(

     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children:[

           heading("Syllabus"),

          Container(

            height: 300.0,
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            
            child: FutureBuilder(
                
                future: getsyllabus(),
                
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    
                    return Center(
                      child: Text("Loading..."),
                    );
                  
                  } else {
                  
                    return ListView.builder(
                        
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          
                          return ListTile(
                            
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Icon(Icons.fiber_manual_record,size:12.0),
                            ),
                            title: Text(snapshot.data[index]),
                            
                          );
                        });
                  }
                }),
          ),
                
        heading("Instructor"),
    
        ListTile(

          leading:  Container(
              height:100.0, 
              width:100.0,
              margin: EdgeInsets.symmetric(horizontal:30.0),
              child: Icon(Icons.person,size: 100.0,color: Colors.grey,), 
            ),

          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
    
                  children: [
                    Text(metadata.data()["instructor"]["instructorName"]+"\n",style: TextStyle(fontSize: 15.0)),
                    Text(metadata.data()["instructor"]["instructor Qualification"]+"\n",style: TextStyle(fontSize: 15.0)),
                    Text(metadata.data()["instructor"]["current Status"]+"\n",style: TextStyle(fontSize: 15.0)),
                ],),
          ),

        )

       ]
     ),
  );
}

courseBannerLayout(context,metadata,visibility){
  
    var  courseName = metadata.data()["courseName"];
    var  imagePath = metadata.data()["imagePath"];
    var  courseDuration = metadata.data()["courseDuration"];
    // var courseId = metadata.reference.documentID;
    var courseId = metadata.data()["courseId"];

    
    return Container(
        
        padding: EdgeInsets.symmetric(vertical: 25.0),
    
        child: Row(
    
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
    
            Container(
              height: 80.0,width: 80.0,
              child: Image.network(imagePath,fit: BoxFit.cover,)
    
            ),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    
                Container(
                            width: 150.0,  
                            child: Text(courseName,style: TextStyle(fontSize: 20.0))
                ),

                SizedBox(height:10.0),
                Text("Duration:"+ courseDuration.toString() +" hrs" ,style: TextStyle(fontSize: 15.0)),
                
                Visibility(
                  visible: visibility,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(65.0, 20.0, 0.0, 0.0),
                    
                    child: ElevatedButton(      //change it
                      child: Text("Enroll",style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff5808e5))),
                      
                      onPressed: () async{

                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        final User firebaseUser = _auth.currentUser;
                        CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');

                        var result = await collectionReference
                        .where("userId", isEqualTo: firebaseUser.uid)
                        .get();

                        result.docs[0].reference.update({"courseEnrolled": FieldValue.arrayUnion([courseId]) });

                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseMaterial(metadata: metadata,),
                        ),  
                      );
                      }
                    )
                  )
                )
    
            ],)
          ],)
      );
  }