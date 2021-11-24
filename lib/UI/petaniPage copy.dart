// import 'package:flutter/material.dart';
// import 'package:tanijaya/Models/errMsg.dart';
// import 'package:tanijaya/Models/petani.dart';
// import 'package:tanijaya/Services/apiStatic.dart';
// import 'package:tanijaya/UI/PPL/inputPetani.dart';
// import 'package:tanijaya/UI/detailPetaniPage.dart';
// import 'package:tanijaya/UI/widget/buttomBar.dart';

// class PetaniPage extends StatefulWidget {
//   @override
//   _PetaniPageState createState() => _PetaniPageState();
// }

// class _PetaniPageState extends State<PetaniPage> {
//   late ErrorMSG response;
//   void deletePetani(id) async{
//     response=await ApiStatic.deletePetani(id);
//     final snackBar = SnackBar(content: Text(response.message),);        
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Daftar Petani"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => InputPetani(petani: Petani(
//             idPenjual: 0,
//             idKelompokTani: 0,
//             nama: '',
//             namaKelompok:'',
//             status:'N',
//             createdAt: '',
//             updatedAt: '',
//             telp: '',
//             alamat: '',
//             nik: '',
//             foto: ''
//           ))));
//         },
//       ),
//       body: FutureBuilder<List<Petani>>(
//           future: ApiStatic.getPetani(),
//           builder: (context, snapshot){
//             if (snapshot.connectionState==ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//             } else {
//                 List<Petani> listPetani=snapshot.data!;
//                 return Container(
//                   padding: EdgeInsets.all(5),
//                   child: ListView.builder(
//                     itemCount: listPetani.length,
//                     itemBuilder: (BuildContext context, int index)=>Column(
//                       children: [
//                         InkWell(
//                           onTap: (){
//                               Navigator.of(context).push(new MaterialPageRoute(
//                                 builder: (BuildContext context)=>DetailPetaniPage(petani: listPetani[index],)
//                               ));
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(5),
//                             margin: EdgeInsets.only(top: 10),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(3),
//                               color: Colors.white,
//                               border: Border.all(width: 1, color: listPetani[index].status=='Y'?Colors.green:Colors.orange)
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Image.network(ApiStatic.host+'/'+listPetani[index].foto, width: 30,),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 5,right:5),
//                                   child: Column(
//                                     children: [
//                                       Text(listPetani[index].nama),
//                                       Text(listPetani[index].namaKelompok, style: TextStyle(fontSize: 8),),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: (){
//                                         Navigator.of(context).push(new MaterialPageRoute(
//                                             builder: (BuildContext context)=>InputPetani(petani: listPetani[index],)
//                                           ));
//                                       },
//                                       child: Icon(Icons.edit)),
//                                     GestureDetector(
//                                       onTap: (){
//                                         deletePetani(listPetani[index].idPenjual);
//                                       },
//                                       child: Icon(Icons.delete)),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//             }
//           },
//       ),
//       bottomNavigationBar: buildBottomBar(1, context)
//     );
//   }
// }