import 'package:tanijaya/Models/petani.dart';

class ApiStatic{
  static Future<List<Petani>> getPetani() async{
    List<Petani> petani=[];
    for (var i = 0; i < 10; i++) {
        petani.add(
          Petani(
            idPenjual: i, nama: "Nama Petani"+i.toString(), nik: "123"+i.toString(),alamat: "Alamat", telp: "0362",foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrynWADIdRZwu5T-vrTuGR0a7Rk7zJ4yxP9LiRJB88TFdVFIxaIa_qtc1EzZrBQWcDPkg&usqp=CAU",idKelompokTani: 1,status: "Y",namaKelompok: "Jaya Mula", createdAt: "",updatedAt: ""
          )
        ); 
    }
    return petani;
  }
}