import 'package:calendar/blocs/blocs.dart';
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
  ShowCalendar({Key key, this.title, @required this.months}) : super(key: key);
  final List<String> months;
  final String title;

  @override
  _ShowCalendarState createState() =>
      new _ShowCalendarState(title: title, months: months);
}

class _ShowCalendarState extends State<ShowCalendar> {
  DateTime _currentDate = DateTime.now();
  int _currentYear = DateTime.now().year;
  DateTime _targetDateTime = DateTime.now();
  List<Event> currentEvents;
  final String title;
  int oldindex = 0;
  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
  CalendarCarousel _calendarCarousel;
  PanelController _pc = new PanelController();
  List<String> months;
  _ShowCalendarState({this.title, @required this.months});

  @override
  Widget build(BuildContext context) {
    final _queryData = MediaQuery.of(context);
    return BlocBuilder<EventoListBloc, EventoListState>(
        builder: (context, state) {
      if (state is Loaded) {
        var eventi = state.eventi;
        _markedDateMap.events.clear();
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
            BlocProvider.of<EventoListBloc>(context)
                .add(FiltraEventos(data: date));
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _queryData.textScaleFactor * 13),
                ));
          },
          selectedDayButtonColor: Colors.blue,
          selectedDayBorderColor: Colors.transparent,
          selectedDateTime: _currentDate,
          selectedDayTextStyle: TextStyle(
            color: Colors.white,
          ),
          pageSnapping: true,
          weekFormat: false,
          showHeader: false,
          height: _queryData.size.height * 0.35,
          childAspectRatio: _queryData.devicePixelRatio * 0.35,
          targetDateTime: _targetDateTime,

          /// weekday
          weekdayTextStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
              fontSize: _queryData.textScaleFactor * 14),
          weekendTextStyle: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.w500,
              fontSize: _queryData.textScaleFactor * 13),
          daysTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: _queryData.textScaleFactor * 13),
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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(_queryData.size.height * 0.065),
              child: AppBar(
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 5),
                    child: Text(_currentYear.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: _queryData.textScaleFactor * 17)),
                  )
                ],
                elevation: 0.0,
                backgroundColor: Colors.blue,
              ),
            ),
            body: SlidingUpPanel(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                minHeight: 0,
                maxHeight: _queryData.size.height * 0.5,
                controller: _pc,
                panel: Container(
                  padding: EdgeInsets.only(
                      top: _queryData.size.height * 0.05,
                      left: _queryData.size.width * 0.05,
                      right: _queryData.size.width * 0.05),
                  child: BlocProvider(
                    create: (context) => AddFormBloc(),
                    child: AddForm(),
                  ),
                ),
                body: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                  Container(
                    height: _queryData.size.height * 0.06,
                    margin:
                        EdgeInsets.only(bottom: _queryData.size.height * 0.02),
                    alignment: Alignment.center,
                    child: new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            alignment: Alignment.center,
                            child: Text(this.months[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _queryData.textScaleFactor * 30,
                                    fontWeight: FontWeight.bold)));
                      },
                      itemCount: months.length,
                      pagination: null,
                      control: null,
                      viewportFraction: _queryData.devicePixelRatio * 0.12,
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
                    margin: EdgeInsets.symmetric(
                        horizontal: _queryData.size.width * 0.08),
                    padding: EdgeInsets.all(_queryData.size.width * 0.06),
                    child: _calendarCarousel,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: _queryData.size.width * 0.08),
                          child: Text(
                            "Eventi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _queryData.textScaleFactor * 17),
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: _queryData.size.width * 0.08),
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
                      eventi: state.eventiFiltrati,
                    ),
                  ),
                  Container(
                    height: _queryData.size.height * 0.2,
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
