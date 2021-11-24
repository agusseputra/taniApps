

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanijaya/Models/errMsg.dart';
import 'package:tanijaya/Models/kelompok.dart';
import 'package:tanijaya/Models/petani.dart';

class ApiStatic{
  static final host='http://192.168.43.189/webtani/public';
  static final _token="8|x6bKsHp9STb0uLJsM11GkWhZEYRWPbv0IqlXvFi7";
  static getHost(){
    return host;
  }
  // static Future<List<Petani>> getPetani2() async{
  //   List<Petani> petani=[];
  //   for (var i = 0; i < 10; i++) {
  //       petani.add(
  //         Petani(
  //           idPenjual: i, nama: "Nama Petani"+i.toString(), nik: "123"+i.toString(),alamat: "Alamat", telp: "0362",foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrynWADIdRZwu5T-vrTuGR0a7Rk7zJ4yxP9LiRJB88TFdVFIxaIa_qtc1EzZrBQWcDPkg&usqp=CAU",idKelompokTani: 1,status: "Y",namaKelompok: "Jaya Mula", createdAt: "",updatedAt: ""
  //         )
  //       ); 
  //   }
  //   return petani;
  // }
  static Future<List<Petani>> getPetani() async{
    //String response='{"current_page":1,"data":[{"id_penjual":1,"nama":"Sugi Tumang","nik":"39949","alamat":"Srikandi","telp":"0882788","foto":"petanis\/farmer_10763.png","id_kelompok_tani":1,"status":"Y","created_at":null,"updated_at":null,"nama_kelompok":"Suda Merta"},{"id_penjual":2,"nama":"Jaya Suda","nik":"38839","alamat":"Bekisar","telp":"099383","foto":"petanis\/images.jpg","id_kelompok_tani":1,"status":"Y","created_at":null,"updated_at":null,"nama_kelompok":"Suda Merta"}],"first_page_url":"http:\/\/192.168.43.189\/belajarapi\/public\/api\/petani?page=1","from":1,"last_page":1,"last_page_url":"http:\/\/192.168.43.189\/belajarapi\/public\/api\/petani?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"http:\/\/192.168.43.189\/belajarapi\/public\/api\/petani?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"http:\/\/192.168.43.189\/belajarapi\/public\/api\/petani","per_page":10,"prev_page_url":null,"to":2,"total":2}';
    try {
      final response= await http.get(Uri.parse("$host/api/petani/"),
      headers: {
        'Authorization':'Bearer '+_token,
      });     
     // print('ss1');
      if (response.statusCode==200) {
        //print('ss2');        
        var json=jsonDecode(response.body);
        //print(json);
        final parsed=json['data'].cast<Map<String, dynamic>>();
        return parsed.map<Petani>((json)=>Petani.fromJson(json)).toList();
      } else {
        return [];
      }
      } catch (e) {
        return [];
    }
  }
  static Future<List<Petani>> getPetaniFilter(int pageKey, String _s,String _selectedChoice) async{
    try {
      final response= await http.get(Uri.parse("$host/api/petani?page="+pageKey.toString()+"&s="+_s+"&publish="+_selectedChoice),
      headers: {
        'Authorization':'Bearer '+_token,
      });      
      if (response.statusCode==200) {
        var json=jsonDecode(response.body);
        //print(json);
        final parsed=json['data'].cast<Map<String, dynamic>>();
        return parsed.map<Petani>((json)=>Petani.fromJson(json)).toList();
      } else {
        return [];
      }
      } catch (e) {
        return [];
    }
  }
  static Future<List<Kelompok>> getKelompokTani() async{
    try {
      final response= await http.get(Uri.parse("$host/api/kelompoktani"),
      headers: {
        'Authorization':'Bearer '+_token,
      });      
      if (response.statusCode==200) {
        var json=jsonDecode(response.body);
        final parsed=json.cast<Map<String, dynamic>>();
        return parsed.map<Kelompok>((json)=>Kelompok.fromJson(json)).toList();
      } else {
        return [];
      }
      } catch (e) {
        return [];
    }
  }
  static Future<ErrorMSG> savePetani(id, petani, filepath) async {
    try {
      var url=Uri.parse('$host/api/petani');
      if(id != 0){
        url=Uri.parse('$host/api/petani/'+id.toString());
      }      
      var request = http.MultipartRequest('POST', url);
      request.fields['nama']=petani['nama'];
      request.fields['nik']=petani['nik'];
      request.fields['alamat']=petani['alamat'];
      request.fields['telp']=petani['telp'];
      request.fields['status']=petani['status'];
      request.fields['id_kelompok_tani']=petani['id_kelompok_tani'].toString();      
      if(filepath!=''){
        request.files.add(await http.MultipartFile.fromPath('foto', filepath));
      }
      request.headers.addAll(
        {
          'Authorization':'Bearer '+_token,
        }
      );
      var response = await request.send();
      //final response = await http.post(Uri.parse('$_host/panen'), body:_panen);
      if (response.statusCode == 200) {
          //return ErrorMSG.fromJson(jsonDecode(response.body));
          final respStr = await response.stream.bytesToString();
          //print(jsonDecode(respStr));
          return ErrorMSG.fromJson(jsonDecode(respStr));
        } else {
          //return ErrorMSG.fromJson(jsonDecode(response.body));
          return ErrorMSG(success: false,message: 'err Request');
        }
    } catch (e) {
      ErrorMSG responseRequest = ErrorMSG(success: false,message: 'error caught: $e');
      return responseRequest;
    }    
  }
  static Future<ErrorMSG> deletePetani(id) async {
    try {
      final response = await http.delete(Uri.parse('$host/api/petani/'+id.toString()),
      headers: {
          'Authorization':'Bearer '+_token,
        });
      if (response.statusCode == 200) {
          return ErrorMSG.fromJson(jsonDecode(response.body));
        } else {          
          return ErrorMSG(success: false,message: 'Err, periksan kembali inputan anda');
        }        
    } catch (e) {
      ErrorMSG responseRequest = ErrorMSG(success: false,message: 'error caught: $e');
      return responseRequest;
    }
  }
}