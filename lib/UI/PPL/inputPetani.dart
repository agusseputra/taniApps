import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanijaya/Models/errMsg.dart';
import 'package:tanijaya/Models/kelompok.dart';
import 'package:tanijaya/Models/petani.dart';
import 'package:tanijaya/Services/apiStatic.dart';
import 'package:tanijaya/UI/petaniPage.dart';

class InputPetani extends StatefulWidget {
  final Petani petani;
  InputPetani({required this.petani});
  @override
  _InputPetaniState createState() => _InputPetaniState();
}

class _InputPetaniState extends State<InputPetani> {
  final _formkey=GlobalKey<FormState>();
  late TextEditingController   nama, nik, alamat, telp; 
  late List<Kelompok> _kelompok=[];
  late int idKelompok=0;
  late int idPenjual=0;
  bool _isupdate=false;
  bool _validate=false;
  bool _success=false;
  late ErrorMSG response;
  late String _status='N';
  late String _imagePath="";
  late String _imageURL="";
  final ImagePicker _picker = ImagePicker();
  void getKelompok() async {
  final response = await ApiStatic.getKelompokTani();
    setState(() {
        _kelompok=response.toList();
      });
  }
  void submit() async{
    if(_formkey.currentState!.validate()){      
      _formkey.currentState!.save();
      var params =  {
          'nama':nama.text.toString(),
          'nik':nik.text.toString(),
          'alamat' : alamat.text.toString(),
          'telp' :telp.text.toString(),
          'status':_status,
          'id_kelompok_tani' :idKelompok,
        }; 
        response=await ApiStatic.savePetani(idPenjual,params,_imagePath);
        _success=response.success;
        final snackBar = SnackBar(content: Text(response.message),);        
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (_success) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context)=>PetaniPage()
          ));
        }
    }else {
      _validate = true;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    nama = TextEditingController();
    nik= TextEditingController();
    alamat= TextEditingController();
    telp= TextEditingController();
    getKelompok();
    if(widget.petani.idPenjual!=0){
      //ApiStatic.detailPetani(widget.id).then((Petani result){
        idPenjual=widget.petani.idPenjual;
        nama = TextEditingController(text: widget.petani.nama);
        nik= TextEditingController(text: widget.petani.nik);
        alamat= TextEditingController(text: widget.petani.alamat);
        telp= TextEditingController(text: widget.petani.telp);
        idKelompok=widget.petani.idKelompokTani;
        _status=widget.petani.status;
        _isupdate=true;
        _imageURL=ApiStatic.host+'/'+widget.petani.foto;
      //});
    }    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _isupdate ? Text(widget.petani.nama) : Text('Input Data'),
      ),
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Form(
        key: _formkey,
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  controller: nama,
                  validator: (u) => u == "" ? "Wajib Diisi " : null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.perm_identity),
                    hintText: 'Nama Petani',
                    labelText: 'Nama Petani',
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: nik,
                    validator: (u) => u == "" ? "Wajib Diisi " : null,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.assignment_ind),
                      hintText: 'NIK Petani',
                      labelText: 'NIK Petani',
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: DropdownButtonFormField(
                      value: idKelompok==0?null:idKelompok,
                      hint: Text("Pilih Kelompok"),
                      decoration: const InputDecoration(
                          icon: Icon(Icons.category_rounded),
                        ),
                      items: _kelompok.map((item) {
                          return DropdownMenuItem(
                            child: Text(item.namaKelompok),
                            value: item.idKelompokTani.toInt(),
                          );
                        }).toList(),
                      onChanged: (value){
                        setState(() {
                            idKelompok=value as int;
                          });
                      },
                      validator: (u) => u == null ? "Wajib Diisi " : null,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: telp,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Nomor HP',
                          labelText: 'Nomor HP Petani',
                        ),
                        validator: (u) => u == "" ? "Wajib Diisi " : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: alamat,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_on),
                          hintText: 'Alamat',
                          labelText: 'Alamat Petani',
                        ),
                        validator: (u) => u == "" ? "Wajib Diisi " : null,
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.image),
                        Flexible(
                        child: _imagePath != '' ? GestureDetector(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(_imagePath),
                                fit: BoxFit.fitWidth,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 5,
                              ),
                            ),
                        onTap: () {
                            getImage(ImageSource.gallery);
                          }
                        ) : _imageURL != '' ? GestureDetector(
                              child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(_imageURL,
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                        ),
                        onTap: () {
                            getImage(ImageSource.gallery);
                          }
                        ) : GestureDetector(
                          onTap: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            height: 100,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                ),
                                Text("Ambil Gambar")
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.greenAccent, width: 1))
                            ),
                          ),
                        )
                            
                      )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.visibility),
                        Row(
                          children: <Widget>[
                            new Radio(
                              value: "Y",
                              groupValue: _status,
                              onChanged:(String? newValue) {
                                      setState(() {
                                        _status = newValue!.toString();
                                      });
                                    },
                            ),
                            new Text(
                              'Aktif'
                            ),
                            new Radio(
                              value: "N",
                              groupValue: _status,
                              onChanged:(String? newValue) {
                                      setState(() {
                                        _status = newValue!.toString();
                                      });
                                    },
                            ),
                            new Text(
                              'Tidak'
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'SIMPAN',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: (){
                          submit();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    ), 
    );
  }
  Future getImage(ImageSource media) async {
    var img = await _picker.pickImage(source: media);
    //final pickedImageFile = File(img!.path);
    setState(() {
      _imagePath=img!.path;
      print(_imagePath);
    });
  }
}