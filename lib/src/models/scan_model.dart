import 'package:latlong/latlong.dart';

class ScanModel {

    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
    }){
      if(valor.contains('http')){
        tipo = 'http';
      }else{
        tipo = 'geo';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };

    bool get isHttp {
      return tipo.contains("http");
    }

    getLatLng(){
      final splitLatLng = valor.substring(4).split(',');
      return LatLng( double.parse(splitLatLng[0]) , double.parse(splitLatLng[1]));
    }
}