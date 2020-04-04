import 'package:calendar/blocs/blocs.dart';
import 'package:calendar/models/evento_model.dart';
import 'package:calendar/screens/addeventoform_screen.dart';
import 'package:calendar/widgets/eventi_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:calendar/blocs/evento/evento.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ShowCalendar extends StatefulWidget {
  ShowCalendar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShowCalendarState createState() => new _ShowCalendarState(title: title);
}

class _ShowCalendarState extends State<ShowCalendar> {
  DateTime _currentDate = DateTime.now();
  int _currentYear = DateTime.now().year;
  DateTime _targetDateTime = DateTime.now();
  List<Event> currentEvents;
  final String title;
  List<String> months;
  int oldindex = 0;
  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
  CalendarCarousel _calendarCarousel;
  PanelController _pc = new PanelController();

  _ShowCalendarState({this.title});

  @override
  void initState() {
    super.initState();
    months = _ordinaMesi();
  }

  List<String> _ordinaMesi() {
    List<String> months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre'
    ];
    var nuovimesi = List<String>(12);
    int currentMonth = DateTime.now().month;
    for (int i = 0; i < 12; i++) {
      if (currentMonth > 12) {
        currentMonth = 1;
      }
      nuovimesi[i] = months[currentMonth - 1];
      currentMonth++;
    }
    for (int i = 0; i < 12; i++) {
      print(nuovimesi[i]);
    }
    return nuovimesi;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return BlocBuilder<EventoListBloc, EventoListState>(
        builder: (context, state) {
      if (state is Loaded) {
        var eventi = state.eventi;
        for (var i = 0; i < eventi.length; i++) {
          _markedDateMap.events.putIfAbsent(eventi[i].dataInizio, () => []);
          _markedDateMap.events[eventi[i].dataInizio].add(new Event(
              date: eventi[i].dataInizio, title: eventi[i].descrizione));
        }
        _calendarCarousel = CalendarCarousel<Event>(
          todayBorderColor: Colors.transparent,
          onDayPressed: (DateTime date, List<Event> events) {
            this.setState(() {
              _currentDate = date;
            });
            //_pc.open();
            // BlocProvider.of<EventoListBloc>(context).add(AddEvento(evento:Evento(dataFine: date,dataInizio: date,descrizione: "agginto")));
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
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Text(
                  event.date.day.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ));
          },
          selectedDayButtonColor: Colors.blue,
          selectedDayBorderColor: Colors.transparent,
          selectedDateTime: _currentDate,
          selectedDayTextStyle: TextStyle(
            color: Colors.white,
          ),
          headerTextStyle: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          pageSnapping: true,
          weekFormat: false,
          showHeader: false,

          height: 270,
          childAspectRatio: 0.8,
          targetDateTime: _targetDateTime,

          /// weekday
          weekdayTextStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
              fontSize: 17),
          weekendTextStyle: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
              fontSize: 17),
          daysTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          todayTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
          minSelectedDate: DateTime(1970, 1, 1),
          maxSelectedDate: DateTime.now().add(Duration(days: 3650)),
          onCalendarChanged: (DateTime date) {
            this.setState(() {
              _targetDateTime = date;
            });
          },
          isScrollable: false,

          onDayLongPressed: (DateTime date) {},
        );

        return new Scaffold(
            backgroundColor: Colors.blue,
            /*  bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  title: Text('Todos'),
                ),
              ],
              selectedItemColor: Colors.blue,
            ),*/
            appBar: AppBar(
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10),
                  child: Text(_currentYear.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                )
              ],
              elevation: 0.0,
              backgroundColor: Colors.blue,
            ),
            body: SlidingUpPanel(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                minHeight: 0,
                maxHeight: 300,
                controller: _pc,
                panel: BlocProvider(
                  create: (context) => AddFormBloc(),
                  child: AddForm(),
                ),
                body: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 30),
                    alignment: Alignment.center,
                    child: new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            alignment: Alignment.center,
                            child: Text(this.months[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold)));
                      },
                      itemCount: months.length,
                      pagination: null,
                      control: null,
                      viewportFraction: 0.48,
                      fade: 0.05,
                      scale: 0.3,
                      onIndexChanged: (index) {
                        setState(() {
                          if ((index >= oldindex && (index - oldindex != 11)) ||
                              (index - oldindex == -11)) {
                            _targetDateTime = DateTime(_targetDateTime.year,
                                _targetDateTime.month + 1);
                            oldindex = index;
                            _currentYear = _targetDateTime.year;
                          } else {
                            _targetDateTime = DateTime(_targetDateTime.year,
                                _targetDateTime.month - 1);
                            oldindex = index;
                            _currentYear = _targetDateTime.year;
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24.0))),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    padding: EdgeInsets.all(30.0),
                    child: _calendarCarousel,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(30),
                          child: Text(
                            "Eventi",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      Container(
                          margin: EdgeInsets.all(30),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              _pc.open();
                            },
                          )),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: EventiList(
                      eventi: state.eventi,
                    ),
                  )
                ]))));
      } else if (state is Loading) {
        return Container(
          color: Colors.white,
        );
      } else {
        return Center(
          child: Text('failed to fetch posts'),
        );
      }
    });
  }
}
