import 'package:catat_uang/models/category.dart';
import 'package:catat_uang/models/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDatabase database = AppDatabase();
  bool isExpanse = true;

  List<String> list = ['MAKAN DAN JAJAN', 'BENSIN', 'KUOTA', 'LISTRIK'];
  late String dropDownValue = list.first;

  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future insert(
      int amount, DateTime date, String nameDetail, int categoryId) async {}

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Tambah Transaksi"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: isExpanse,
                    onChanged: (bool value) {
                      setState(() {
                        isExpanse = value;
                      });
                    },
                    inactiveTrackColor: Colors.greenAccent,
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    isExpanse ? "PENGELUARAN" : "PEMASUKAN",
                    style: GoogleFonts.montserrat(fontSize: 14),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: "Jumlah"),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kategori',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                ),
              ),
            ),
            FutureBuilder<List<Category>>(
                future: getAllCategory(2),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        print(snapshot.toString());
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<String>(
                              value: dropDownValue,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {}),
                        );
                      } else {
                        return Center(
                          child: Text('Data Kosong'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Tidak Ada Data'),
                      );
                    }
                  }
                }),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: InputDecoration(labelText: "Masukkan Tanggal"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2099));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    dateController.text = formattedDate;
                  }
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: detailController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: "Detail"),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    print('amount :' + amountController.text);
                    print('date :' + dateController.text);
                    print('detail :' + detailController.text);
                  },
                  child: Text("Simpan")),
            ),
          ],
        )),
      ),
    );
  }
}
