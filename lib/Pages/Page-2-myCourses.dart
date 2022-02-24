import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Page-3-CourseHome.dart';

class MyCourses extends StatefulWidget { 

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {

  Future data;

  Future getdata() async{

    final databaseReference =FirebaseFirestore.instance;
    QuerySnapshot query =await databaseReference.collection("course").get();
    return query.docs;
  
  }

  void initState(){
    super.initState();
    data = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: data,
        builder: (context,snapshot){

        if(snapshot.connectionState == ConnectionState.waiting){
          
          return Center(child: Text("Loading..."),);
        
        } else{
          
          return ListView.builder(
            
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){

                  return InkWell(

                    child: courseBannerLayout(context,snapshot.data[index],false),
                    
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CourseHome(metadata: snapshot.data[index],)));
                    },

                  );

                  }
          );
        }

      }),
      
    );
  }
}