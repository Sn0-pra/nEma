import 'package:flutter/material.dart';
import 'Page-2-allCourses.dart';
import 'commonComponents.dart';
import 'package:newtrial/Pages/Page-2-myCourses.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:appbar(context),
      body: Center(
        child: ListView(
          
          children: <Widget>[
            
            banner("To me there was magic in learning \n - Michelle Obama","assets/image4.jpg"),
            tabView()
            
          ],
        ),
        
      ),
    );
  }
}

tabView(){
  
return Container(

        height:450.0,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Color(0xffffffff),
              title: TabBar(
                labelColor: Colors.black,
                indicatorColor: Color(0xff5808e5),
                tabs: [
                  Tab(text: 'My Courses'),
                  Tab(text: 'All Courses'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                  MyCourses(),
                  AllCourses()
              ],
            ),
          ),
    ),
      );

}