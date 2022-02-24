import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'commonComponents.dart';

class SignupPage extends StatelessWidget {
  
  final _auth;

  SignupPage(this._auth);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passController2 = TextEditingController();
  final emailhiding=false;
  final passhiding=true;

  static bool _success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("E-Learning"),
            backgroundColor:Color(0xff5808e5),
  ),
       //resizeToAvoidBottomPadding: false,

      body: Container(

        padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),

        decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/login_screen.jpg"),  
              fit: BoxFit.fill,
              )
            ),
        
        child: Form(

            key: _formKey,

            child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: [

                Center(child: Text('Sign up',style: TextStyle(color: Color(0xff5808e5),fontSize:35.0, fontWeight: FontWeight.w600),)),
                
                SizedBox(height:40),
                
                inputBox("E-mail Address",TextInputType.emailAddress,_emailController,emailhiding),
                
                SizedBox(height:20),
                
                inputBox("Password",TextInputType.visiblePassword,_passController,passhiding),
                
                SizedBox(height:20),
                
                inputBox("Confirm Password",TextInputType.visiblePassword,_passController2,passhiding),
                
                SizedBox(height:30),
                
                ElevatedButton(
                  child: Text('SignUp',style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff5808e5))),
                  onPressed: () {

                    if(_formKey.currentState.validate()){

                    _register(context);

                  }

                  },
              
            )
            ],
          ),
        ),

      ),
      
    );
  }

//   insertUser(emailId,userId){
//   CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
//   Map<String,dynamic> userdata = {'uerId':userId ,'userName': emailId};
//   collectionReference.add(userdata);
// }

checkuserindb(email) {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
  // QuerySnapshot querySnapshot = await collectionReference.get();  
   collectionReference.get()
    .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          if(email != doc["email"]) {
            return true;
          }     
        })
    });
    return false;
}


  void _register(BuildContext context) async{

   if(_passController2.text == _passController.text){

      try{

      final User user = (
                    await _auth.createUserWithEmailAndPassword(
                      email: _emailController.text, 
                      password: _passController.text)
                  ).user;

                  try{

                    if(user != null){

                      // CollectionReference firestoreInstance = FirebaseFirestore.instance.collection('user');
                      
                        // if(checkuserindb(user.email)){

                        //     print("user need to be added");
                        //     print(checkuserindb(user.email));
                        //   //  showAlertDialog(context,"Entered email id already in use","Error");
                        //   // print("checkuseindb");
                          
                        // }
                        // else{

                        //   print("user need not to be added");

                          user.sendEmailVerification().whenComplete(() {

                            _success = true;
                            showAlertDialog(context,"Mail sent for verification.\n Please verify it.","Sucessful Registration");
                            _emailController.clear();
                            _passController.clear();
                            _passController2.clear();

                            });
                          CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
                          Map<String,dynamic> userdata = {'userId':user.uid ,'userName': user.email};
                          collectionReference.add(userdata);

                          //   firestoreInstance.doc(user.uid).set(
                          // {
                          //   // user document id is same as fireauth id
                          //   "email": user.email
                          // }).then((_){
                            
                          //   

                          // });

                        // }

                      }else{

                        _success = false;
                        showAlertDialog(context,"Please check entered email id and password","Error");
                      
                      }

                  }catch(e){
                      print(e);
                  }
      print("Account created");

    } on FirebaseAuthException catch (e){

      if (e.code == 'weak-password') {
        print('The password provided is too weak or less than 6 characters long');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

    } catch (e) {
      print(e);
    }

   }else{
     showAlertDialog(context, "Confirm paswword does not match password","Error");
   }

  }
  
}
