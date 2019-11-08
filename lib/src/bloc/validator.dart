import 'dart:async';

import 'package:qareaderapp/src/models/scan_model.dart';

class Validators{
  final validaGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => !s.isHttp).toList();
      sink.add(geoScans);
    }
  );

  final validaHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => s.isHttp).toList();
      sink.add(geoScans);
    }
  );
}