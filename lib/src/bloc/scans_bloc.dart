import 'dart:async';

import 'package:qareaderapp/src/bloc/validator.dart';
import 'package:qareaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validaGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validaHttp);

  dispose(){
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getScan());
  }

  addScan(ScanModel scanModel)async{
    await DBProvider.db.addScan(scanModel);
    getScans();
  }

  deleteScan(int id) async{
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteScans() async{
    await DBProvider.db.deleteAllScan();
     _scansController.sink.add([]);
  }

}