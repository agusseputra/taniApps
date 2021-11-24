import 'package:flutter/material.dart';
import 'package:tanijaya/UI/homePage.dart';
import 'package:tanijaya/UI/petaniPage.dart';

Widget buildBottomBar(index, BuildContext context){
  return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (i){
            switch (i) {
              case 0:
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context)=>HomePage()
                  ));
                break;
              case 1:
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context)=>PetaniPage()
                  ));
                break;
              default:
            }
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), title: Text("Petani")),
          ],
        );
}