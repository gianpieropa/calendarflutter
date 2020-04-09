import 'package:meta/meta.dart';

@immutable
abstract class NavbarEvent {
  final int index;
  NavbarEvent({this.index});
}

class ChangePage extends NavbarEvent {
  ChangePage({@required int index}) : super(index:index);
}
