import 'package:flutter/material.dart';
import 'package:qareaderapp/src/bloc/scans_bloc.dart';
import 'package:qareaderapp/src/models/scan_model.dart';
import 'package:qareaderapp/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {

 final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream : scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
         if(snapshot.hasData){
           final scans = snapshot.data;
           if(scans.length == 0){
             return Center(
               child: Text('No hay información'),
             );
           }

           return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                ),
                onDismissed: (direccion) => scansBloc.deleteScan(scans[i].id),
                child: ListTile(
                  leading: Icon(Icons.map, color:  Theme.of(context).primaryColor,),
                  title: Text(scans[i].valor),
                  subtitle: Text('ID : ${scans[i].id}'),
                  trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor,),
                  onTap: () => utils.launchURL(context, scans[i]),
                ),
              ),
            );

         }else{
           return Center(child: CircularProgressIndicator(),);
         }
      },
    );
  }
}