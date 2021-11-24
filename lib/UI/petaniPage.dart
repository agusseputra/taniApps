import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tanijaya/Models/errMsg.dart';
import 'package:tanijaya/Models/petani.dart';
import 'package:tanijaya/Services/apiStatic.dart';
import 'package:tanijaya/UI/PPL/inputPetani.dart';
import 'package:tanijaya/UI/detailPetaniPage.dart';
import 'package:tanijaya/UI/widget/buttomBar.dart';

class PetaniPage extends StatefulWidget {
  @override
  _PetaniPageState createState() => _PetaniPageState();
}

class _PetaniPageState extends State<PetaniPage> {
  late ErrorMSG response;
  final PagingController<int, Petani> _pagingController=PagingController(firstPageKey: 0);
  late TextEditingController _s;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String _publish="Y";
  int _pageSize=3;
  void deletePetani(id) async{
    response=await ApiStatic.deletePetani(id);
    final snackBar = SnackBar(content: Text(response.message),);        
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> _fetchPage(int pageKey,_s,_publish) async {
    try {
      final newItems = await ApiStatic.getPetaniFilter(pageKey,_s,_publish);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _s=TextEditingController();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _s.text,_publish);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text("Daftar Petani"),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputPetani(petani: Petani(
            idPenjual: 0,
            idKelompokTani: 0,
            nama: '',
            namaKelompok:'',
            status:'N',
            createdAt: '',
            updatedAt: '',
            telp: '',
            alamat: '',
            nik: '',
            foto: ''
          ))));
        },
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
            padding: EdgeInsets.only(top: 100),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RefreshIndicator(
                onRefresh: ()=>Future.sync(
                    ()=>_pagingController.refresh()
                ),
                child: PagedListView<int, Petani>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Petani>(
                    itemBuilder: (context, item, index)=>Container(
                      child: InkWell(
                        onTap: (){
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context)=>DetailPetaniPage(petani: item,)
                              ));
                            },
                        child: Container(
                            height: 100,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                                border: Border.all(width: 1, color: item.status=='Y'?Colors.green:Colors.orange)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(ApiStatic.host+'/'+item.foto, width: 30,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5,right:5),
                                    child: Column(
                                      children: [
                                        Text(item.nama),
                                        Text(item.namaKelompok, style: TextStyle(fontSize: 8),),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(new MaterialPageRoute(
                                              builder: (BuildContext context)=>InputPetani(petani: item,)
                                            ));
                                        },
                                        child: Icon(Icons.edit)),
                                      GestureDetector(
                                        onTap: (){
                                          deletePetani(item.idPenjual);
                                          _pagingController.refresh();
                                        },
                                        child: Icon(Icons.delete)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),            
          ),
          //contaoner untuk background
          Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Petani",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              //contaoner untuk Filter
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Data Petani",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        initialValue: _publish,
                        onSelected: (String result) { 
                            setState(() { 
                              _publish = result; 
                              _pagingController.refresh();
                            }); 
                          },
                        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(child: const Text('Aktif'),value: 'Y'),
                          new PopupMenuItem<String>(child: const Text('Non Aktif'),value: 'N'),
                          new PopupMenuItem<String>(child: const Text('Semua'),value: 'All'),
                          new PopupMenuItem<String>(child: const Text('Deleted'),value: 'del'),
                        ],
                      )
                    ],
                  ),
                  
                ),
              ),
              //contaoner untuk search
             Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          controller: _s,
                          onSubmitted: (_s){
                              _pagingController.refresh();
                          },
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                              hintText: "Masukkan Nama Petani",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ) 
          ],
        ) 
        ),
      bottomNavigationBar: buildBottomBar(1, context)
    );
  }
}