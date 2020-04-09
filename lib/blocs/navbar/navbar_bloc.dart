import 'dart:async';
import 'package:bloc/bloc.dart';
import './navbar.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {

  @override
  NavbarState get initialState => ChangedPage(index: 0);

  @override
  Stream<NavbarState> mapEventToState(NavbarEvent event) async* {
    //yield Loading();
    if (event is ChangePage) {
      yield ChangedPage(index:event.index);
    
    } 
  }
}
