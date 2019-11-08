import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qareaderapp/src/providers/db_provider.dart';
import 'package:qareaderapp/src/utils/utils.dart' as utils;

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController mapController = MapController();
  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;    

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QA'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapController.move(scanModel.getLatLng(), 15);
            },
          )
        ],
      ),
      body: Center(
        child: _createFlutterMap(context, scanModel)
      ),
      floatingActionButton: _createActionButton(context),
    );
  }

  _createFlutterMap(BuildContext context, ScanModel scanModel) {
    return  new FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: scanModel.getLatLng(),
        zoom: 15.0,
      ),
      layers: [
        _createMap(),
        _createBrands(context, scanModel)
      ],
    );
  }

  _createMap(){
    return TileLayerOptions(
          urlTemplate: "https://api.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': '${utils.getTokenMap()}',
            'id': 'mapbox.$tipoMapa',
          },
          //streets, dark , ligth, outdoors , satellite
        );
  }

  _createBrands(BuildContext context, ScanModel scanModel) {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scanModel.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on,
              size: 60.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );
  }

  _createActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        if(tipoMapa == 'streets'){
          tipoMapa = 'dark';
        }else if (tipoMapa == 'dark'){
          tipoMapa = 'light';
        }else if (tipoMapa == 'light'){
          tipoMapa = 'outdoors';
        }else if (tipoMapa == 'outdoors'){
          tipoMapa = 'satellite';
        }else{
          tipoMapa = 'streets';
        }
        setState(() {});

      },
    );
  }
}