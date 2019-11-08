import 'package:flutter/cupertino.dart';
import 'package:qareaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(BuildContext context, ScanModel scanModel) async {
  if (scanModel.isHttp) {
    if (await canLaunch(scanModel.valor)) {
      await launch(scanModel.valor);
    } else {
      throw 'Could not launch ${scanModel.valor}';
    }
  }else{
    Navigator.pushNamed(context, 'mapa', arguments: scanModel);
  }
}

String getTokenMap(){
  return "pk.eyJ1IjoiaGFtcGNsIiwiYSI6ImNrMnAzbzdybTAwOGkzaXE2ajhid2J6MnUifQ.qhtc-85aQmsz9NShMGJkRQ";
}
