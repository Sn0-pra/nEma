import 'package:flutter/material.dart';
import 'package:newtrial/main.dart';

appbar(context) {
  return AppBar(
    
    title: Text("E-Learning"),
    backgroundColor: Color(0xff5808e5),
    
    actions: <Widget>[
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              showAlertDialog(context, "You surely want to Log out", "Logout");
            },
            child: Icon(
              Icons.logout,
              size: 22.0,
            ),
          )),
    ],
    
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}

banner(quote, image) {
  return Stack(
    children: [
      Image.asset(image, fit: BoxFit.cover, height: 250.0, width: 400.0),
      Center(
        child: Container(
            margin: const EdgeInsets.all(40.0),
            padding: const EdgeInsets.all(40.0),
            color: Colors.black54,
            child: Center(
                child: Text(quote,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0)))),
      ),
    ],
  );
}

heading(text) {
  return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(text, style: TextStyle(fontSize: 25.0)));
}

button(context, label, route) {
  return ElevatedButton(
    child: Text(label, style: TextStyle(color: Colors.white)),
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff5808e5))),
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
  );
}

showAlertDialog(BuildContext context, alertMsg, alertTitle) {
  if (alertTitle == "Logout") {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget okButton = ElevatedButton(
      child: Text("Ok"),
      onPressed: () {
        signout(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(alertMsg),
      actions: [okButton, cancelButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } else {
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: Text(alertMsg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

inputBox(text, keyboardType, controller, hiding) {
  return TextFormField(
    controller: controller,
    obscureText: hiding,
    decoration: new InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      labelText: text,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    ),
    keyboardType: keyboardType,
    validator: (String val) {
      if (val.isEmpty) {
        return "Please enter valid" + text;
      }
      if (text == "Password") {
        if (val.length <= 6) {
          return "Minimum length of password must be 6";
        }
        return null;
      } else
        return null;
    },
  );
}
