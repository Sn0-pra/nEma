import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Page-3-CourseHome.dart';

class AllCourses extends StatefulWidget { 

  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {

  Future data;
  Future getdata() async{
    final databaseReference =FirebaseFirestore.instance;
    QuerySnapshot query =await databaseReference.collection("course").get();
    return query.docs;
  }
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future getdata() async{

  //  final User firebaseUser = _auth.currentUser;
  //   List<QueryDocumentSnapshot> list = List<QueryDocumentSnapshot>();
  //   QuerySnapshot result = await FirebaseFirestore.instance.collection('user')
  //                       .where("userId", isEqualTo: firebaseUser.uid)
  //                       .get();
  //   var coursedata = result.docs[0].data();

  //   List<String> courseIdArray = List.from(coursedata['courseEnrolled']);
  //   print(courseIdArray);
  //   for(int i=0; i < courseIdArray.length ; i++){
      
  //     var _id = courseIdArray[i];
  //     QuerySnapshot query = await FirebaseFirestore.instance.collection("course").where("courseId", isNotEqualTo:_id).get();
      
  //     list.add(query.docs[0]);
    
  //   }

  //   print(list);
  //   return list;
  // }

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