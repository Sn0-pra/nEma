import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'commonComponents.dart';

class LoginPage extends StatefulWidget {
  
  final auth;

  LoginPage({Key key, @required this.auth}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(auth);
}

class _LoginPageState extends State<LoginPage> {

  var auth;
  _LoginPageState(this.auth);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  static  bool _success;
  // String _userEmail;
  // String _userId;

  final emailhiding = false;
  final passhiding = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     
      appBar: AppBar(
        title: Text("E-Learning"),
        backgroundColor: Color(0xff5808e5),
      ),
      
      body: Container(
        
        padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),
        height: double.infinity,
        
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/login_screen.jpg"),
              fit: BoxFit.fill,
        )),
        
        child: Form(

            key: _formKey,
            
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: [
              
              Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Color(0xff5808e5),
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600),
                  )),
              
              SizedBox(height: 30),
              
              inputBox("E-mail Address", TextInputType.emailAddress,
                  _emailController, emailhiding),
              
              SizedBox(height: 25),
              
              inputBox("Password", TextInputType.visiblePassword, _passController,
                  passhiding),
              
              SizedBox(height: 25),
              
              redirect(context),
              
              SizedBox(height: 30),
              
              ElevatedButton(
                child: Text('Login', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff5808e5))),
                onPressed: () {

                  if(_formKey.currentState.validate()){
                  
                    _signInWithEmailAndPassword(context);

                  }

                },
              )
            ],
          ),
        ),
      ),
    );
  }

_signInWithEmailAndPassword(BuildContext context) async{

  try{

    final User user = (
                      await auth.signInWithEmailAndPassword(
                        email: _emailController.text, 
                        password: _passController.text)
                    ).user;

                    if(user != null && user.emailVerified){
                    
                        _success = true;
                        
                        _emailController.clear();
                        _passController.clear();
                        Navigator.pushReplacementNamed(context, '/homePage');

                    }else{

                        _success = false;
                        showAlertDialog(context,'If your e-mail id is already registered and verified then Please check entered e-mail and password.',"Error");
        
                    
                    }
                    print("User Logged in");
  
    } on FirebaseAuthException catch (e){
    print(e);
    showAlertDialog(context,"Please check e-mail or password.","Error");

   } catch (e) {
      print(e);
      }
    }
  }

redirect(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
          child: Text('Forgot Password?'),
          onTap: () {
            Navigator.pushNamed(context, '/resetPage');
          }),
      InkWell(
        child: Text('Create New Account'),
        onTap: () {
          Navigator.pushNamed(context, '/signupPage');
        },
      )
    ],
  );
}
