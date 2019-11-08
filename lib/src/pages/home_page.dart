import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qareaderapp/src/bloc/scans_bloc.dart';
import 'package:qareaderapp/src/pages/direcciones_page.dart';
import 'package:qareaderapp/src/pages/mapas_page.dart';
import 'package:qareaderapp/src/providers/db_provider.dart';
import 'package:qareaderapp/src/utils/utils.dart' as utils;
import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScansBloc scansBloc = new ScansBloc();
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteScans,
          )
        ],
      ),
      body: _callPage(indexPage),
      bottomNavigationBar: _createNavigationButtonBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(context),
    );
  }

  _createNavigationButtonBar(
    BuildContext context,
  ) {
    return BottomNavigationBar(
      currentIndex: indexPage,
      onTap: (index) {
        setState(() {
          indexPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Direcciones')),
      ],
    );
  }

  _callPage(int index) {
    switch (index) {
      case 0:
        return MapasPage();
        break;
      case 1:
        return DireccionesPage();
        break;
      default:
    }
  }

  _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => _scanQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _scanQR(BuildContext context) async {

    String futureString;

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null) {
      ScanModel scanModel = new ScanModel(valor: futureString);

      scansBloc.addScan(scanModel);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750));
        utils.launchURL(context, scanModel);
      } else {
        utils.launchURL(context, scanModel);
      }
    }
  }
}
