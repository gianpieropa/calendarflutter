import 'dart:async';
import 'package:calendar/main.dart';
import 'package:calendar/showCalendar.dart';
import 'package:flutter/material.dart';
import 'package:calendar/http_client.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as ca;
import 'package:random_color/random_color.dart';

TextStyle techCardTitleStyle = new TextStyle(
    fontFamily: 'Gotham', fontWeight: FontWeight.bold, fontSize: 18);
TextStyle techCardSubTitleStyle = new TextStyle(
    fontFamily: 'Gotham', fontWeight: FontWeight.bold, fontSize: 13);
RandomColor _randomColor = RandomColor();

class CalendarListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchCalendars(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> data = snapshot.data;
          return Container(
            child: _calendarsListView(data),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<String>> _fetchCalendars() async {
    List<String> calendarlist = List<String>();
    final _googleSignIn =
        new GoogleSignIn(scopes: ['https://www.googleapis.com/auth/calendar']);
    try {
      final account = await _googleSignIn.signInSilently();
      print("Successfully signed in as ${account.displayName}.");
    } catch (e) {
      // User not signed in yet. Do something appropriate.
      print("The user is not signed in yet. Asking to sign in.");
      _googleSignIn.signIn();
    }
    final authHeaders = await _googleSignIn.currentUser.authHeaders;

    final httpClient = GoogleHttpClient(authHeaders);

    var calendar = ca.CalendarApi(httpClient);
    await calendar.calendarList.list().then((value) {
      for (var i = 0; i < value.items.length; i++) {
        print(value.items[i].id);
        calendarlist.add(value.items[i].id);
      }
    });
    return calendarlist;
  }

  ListView _calendarsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index], Icons.work,context);
        });
  }

  Ink _tile(String title, IconData icon,context) => Ink(
      child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowCalendar(title: title,)),
            );
          },
          child: Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(10),
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: _randomColor.randomColor(
                  colorHue: ColorHue.blue,
                  colorSaturation: ColorSaturation.highSaturation),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ],
                ))
              ],
            ),
          )));
}
