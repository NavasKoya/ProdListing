import 'package:rxdart/rxdart.dart';

//This is going to be used as Global.
final bloc = Bloc();

class Bloc extends Object implements BaseBloc {
  var _searchValController = BehaviorSubject<String>();

  Function(String) get feedSearchVal => _searchValController.sink.add;

  Stream<String> get receiveSearchVal => _searchValController.stream;

  @override
  dispose() {
    _searchValController?.close();
  }
}

class BaseBloc {
  dispose() {}
}