import 'package:bloc/bloc.dart';
import 'package:calendar/blocs/evento/evento_bloc.dart';
import 'package:calendar/blocs/evento/evento.dart';
import 'package:calendar/blocs/navbar/navbar_bloc.dart';
import 'package:calendar/blocs/navbar/navbar_event.dart';
import 'package:calendar/blocs/todo/todo.dart';
import 'package:calendar/screens/showCalendar.dart';
import 'package:calendar/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/navbar/navbar.dart';
import 'blocs/simple_bloc_delegate.dart';
import 'blocs/todo/todo_bloc.dart';

void main() {
  // BlocSupervisor oversees Blocs and delegates to BlocDelegate.
  // We can set the BlocSupervisor's delegate to an instance of `SimpleBlocDelegate`.
  // This will allow us to handle all transitions and errors in SimpleBlocDelegate.
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _months;
  @override
  void initState() {
    super.initState();
    _months = _ordinaMesi();
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
    //  final _queryData = MediaQuery.of(context);
    var page;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Drive',
        theme: ThemeData(unselectedWidgetColor: Colors.blue,
          primarySwatch: Colors.blue,
        ),
        home: MultiBlocProvider(
            providers: [
              BlocProvider<NavbarBloc>(
                create: (context) {
                  return NavbarBloc();
                },
              ),
              BlocProvider<EventoListBloc>(
                create: (context) {
                  return EventoListBloc()..add(GetEventos());
                },
              ),
              BlocProvider<TodoListBloc>(
                create: (context) {
                  return TodoListBloc()..add(GetTodos());
                },
              ),
            ],
            child:
                BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
              if (state.index == 0) {
                page = ShowCalendar(
                  months: _months,
                );
              } else {
                page = TodosScreen();
              }
              return SafeArea(
                  top: true,
                  bottom: true,
                  child: Scaffold(
                      backgroundColor: Colors.blue,
                      bottomNavigationBar: BottomNavigationBar(
                        currentIndex: state.index,
                        onTap: (index) {
                          BlocProvider.of<NavbarBloc>(context)
                              .add(ChangePage(index: index));
                        },
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            title: Text('Home'),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.check),
                            title: Text('Todos'),
                          ),
                        ],
                        selectedItemColor: Colors.blue,
                      ),
                      body: page));
            })));
  }
}
/*

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/calendar']);
  GoogleSignInAccount googleSignInAccount;

  var signedIn = false;

  Future<void> _loginWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount googleSignInAccount) async {
      if (googleSignInAccount != null) {
        _afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignIn.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storage.write(key: "signedIn", value: "false").then((value) {
          setState(() {
            signedIn = false;
          });
        });
      }
    } else {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      _afterGoogleLogin(googleSignInAccount);
    }
  }

  Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
    googleSignInAccount = gSA;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');

    storage.write(key: "signedIn", value: "true").then((value) {
      setState(() {
        signedIn = true;
      });
    });
  }

  void _logoutFromGoogle() async {
    googleSignIn.signOut().then((value) {
      print("User Sign Out");
      storage.write(key: "signedIn", value: "false").then((value) {
        setState(() {
          signedIn = false;
        });
      });
    });
  }

  Future<void> getCalendarEvents() async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var calendar = ca.CalendarApi(client);
    calendar.calendarList.list().then((value) {
      for (var i = 0; i < value.items.length; i++) {
        print("Id: ${value.items[i].id}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return  Scaffold(
               backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                ),
                body: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20,top:30),
                      alignment: Alignment.centerLeft,
                      child: Text("Calendario",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.blue)),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        child: CalendarListView(),
                      ),
                    ),
                  ],
                ),
              );
          
          }

          /// other way there is no user logged.
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlutterLogo(size: 150),
                    SizedBox(height: 50),
                    _signInButton(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _loginWithGoogle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/
