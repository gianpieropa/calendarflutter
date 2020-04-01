import 'package:calendar/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/content/v2_1.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:googleapis/calendar/v3.dart' as ca;
import 'package:random_color/random_color.dart';

class ShowCalendar extends StatefulWidget {
  ShowCalendar({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ShowCalendarState createState() => new _ShowCalendarState(title: title);
}

class _ShowCalendarState extends State<ShowCalendar> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  List<Event> currentEvents;
  final String title;
  RandomColor _randomColor = RandomColor();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];

  _ShowCalendarState({this.title});

  Future<EventList<Event>> _fetchEvents() async {
    EventList<Event> markedDateMap = new EventList<Event>(events: {});

    final _googleSignIn = new GoogleSignIn(
        scopes: ['https://www.googleapis.com/auth/calendar.events']);
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
    DateTime data;
    String stringa;
    var calendar = ca.CalendarApi(httpClient);
    await calendar.events.list(title).then((value) {
      for (var i = 0; i < value.items.length; i++) {
        print(value.items[i].toJson());
        if (value.items[i].end.dateTime != null) {
          data = value.items[i].end.dateTime;
        } else {
          data = value.items[i].end.date;
        }
        markedDateMap.events.putIfAbsent(data, () => []);
        stringa = value.items[i].summary;
        if (value.items[i].summary == null) {
          stringa = "(Senza titolo)";
        }
        markedDateMap.events[data].add(new Event(date: data, title: stringa));
      }
    });
    return markedDateMap;
  }

  EventList<Event> _markedDateMap;
  CalendarCarousel _calendarCarousel;

  @override
  void initState() {
    super.initState();
    _fetchEvents().then((value) {
      setState(() {
        _markedDateMap = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarousel = CalendarCarousel<Event>(
      todayBorderColor: Colors.transparent,
      onDayPressed: (DateTime date, List<Event> events) {
        //this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
        setState(() {
          currentEvents = events;
          _currentDate2 = date;
        });
      },
      todayButtonColor: Colors.transparent,
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateIconBuilder: (event) {
        return Container(
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              event.date.day.toString(),
              style: TextStyle(color: Colors.white),
            ));
      },
      selectedDayButtonColor: Colors.blue,
      selectedDayBorderColor: Colors.transparent,
      selectedDateTime: _currentDate2,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      headerTextStyle: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      pageSnapping: true,
      weekFormat: false,
      showHeader: true,
      thisMonthDayBorderColor: Colors.grey,

      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? 380
          : 490,
      childAspectRatio:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? 1.0
              : 1.5,
      targetDateTime: _targetDateTime,

      /// weekday
      weekdayTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
      weekendTextStyle: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.bold,
          fontSize: 17),
      daysTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
      todayTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      minSelectedDate: DateTime(1970, 1, 1),
      maxSelectedDate: DateTime.now().add(Duration(days: 3650)),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          backgroundColor: Colors.blue,
        ),
        body: Column(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /* 
                Container(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  alignment: Alignment.centerLeft,
                child: Text("Calendario",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue)),
                ),*/
                //custom icon
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _calendarCarousel,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListWheelScrollView(
           itemExtent: 40,
              children: <Widget>[
                Text(_currentMonth,style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                Text(_currentMonth,style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              height: 180.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 30),
              child: FutureBuilder(
                future: _getEventsList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Event> data = snapshot.data;
                    return SizedBox(
                      height: 150,
                      child: _calendarsListView(data),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container();
                },
              ),
            ),
          )
        ]));
  }
  

  ListView _calendarsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].title, Icons.work, context);
        });
  }

  Ink _tile(String title, IconData icon, context) => Ink(
          child: InkWell(
        splashColor: Colors.blue,
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          width: 180,
          decoration: BoxDecoration(
            /*
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[600],
                    Colors.blue,
                    Colors.tealAccent[400],
                    Colors.tealAccent[700]
                  ]),*/
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: _randomColor.randomColor(
                colorBrightness: ColorBrightness.light),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ));

  Future<List<Event>> _getEventsList() async {
    var values = currentEvents;
    print(currentEvents);
    //await Future.delayed(Duration(seconds: 2));

    return values;
  }
}
