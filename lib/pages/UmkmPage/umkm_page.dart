import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/models/UMKMModel.dart';
import 'package:konek_mob_flutter/pages/UmkmPage/detail_umkm.dart';
import 'package:sp_util/sp_util.dart';

class UMKMPage extends StatefulWidget {
  const UMKMPage({Key? key}) : super(key: key);

  @override
  State<UMKMPage> createState() => _UMKMPageState();
}

class _UMKMPageState extends State<UMKMPage> {
  List<Values> umkmList = [];
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse("${URLs.baseUrl}/api/user/umkm/$token"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final umkmModel = UMKMModel.fromJson(jsonData);
      setState(() {
        umkmList = umkmModel.values!;
      });
    } else {
      throw Exception('Failed to load UMKM data');
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UMKM',
          style: GoogleFonts.outfit().copyWith(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15, right: 15),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  for (int i = 0; i < umkmList.length; i += 2)
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (i < umkmList.length) buildUMKMCard(umkmList[i]),
                          if (i + 1 < umkmList.length)
                            buildUMKMCard(umkmList[i + 1]),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUMKMCard(Values umkmData) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailUMKMPage(
                idUMKM: umkmData.umkmId.toString(),
              ),
            ),
          );
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: umkmData.gambar != ''
                    ? Image.network(
                        umkmData.gambar!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width * 0.3,
                      )
                    : Image.asset(
                        'assets/images/image_default.png',
                        height: MediaQuery.of(context).size.width * 0.3,
                        fit: BoxFit.fill,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      umkmData.nama!,
                      maxLines: 1,
                      style: GoogleFonts.outfit().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xff1F5876),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        umkmData.namaJenisUmkm!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}