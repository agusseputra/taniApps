class Petani{
  Petani({
        required this.idPenjual,
        required this.nama,
        required this.nik,
        required this.alamat,
        required this.telp,
        required this.foto,
        required this.idKelompokTani,
        required this.status,
        required this.namaKelompok,
        required this.createdAt,
        required this.updatedAt,
    });
    int idPenjual;
    String nama;
    String nik;
    String alamat;
    String telp;
    String foto;
    int idKelompokTani;
    String status;
    String namaKelompok;
    String createdAt;
    String updatedAt;
    
    factory Petani.fromJson(Map<String, dynamic> json) => Petani(
        idPenjual: json["id_penjual"] as int,
        nama: (json["nama"]==null || json["nama"]=='')?'':json["nama"].toString(),
        nik: (json["nik"]==null || json["nik"]=='')?'':json["nik"].toString(),
        alamat: json["alamat"].toString(),
        telp: json["telp"].toString(),
        foto: json["foto"].toString(),
        idKelompokTani: json["id_kelompok_tani"] as int,
        status: json["status"].toString(),
        namaKelompok: json["nama_kelompok"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
    );
}