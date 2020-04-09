import 'package:meta/meta.dart';

@immutable
abstract class NavbarState {
  final int index;

  NavbarState({this.index});
}

class InitialNavbarState extends NavbarState {}

class ChangedPage extends NavbarState {
  ChangedPage({@required int index}) : super(index: index);
}
