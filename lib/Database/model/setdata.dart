import 'data.dart';
import 'dataevent.dart';

class SetData extends DataEvent {
  List<Data> datalist;

  SetData(List<Data> data) {
    datalist = data;
  }
}
