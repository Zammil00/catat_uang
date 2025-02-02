import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpanse = true;

  List<String> list = ['MAKAN DAN JAJAN', 'BENSIN', 'KUOTA', 'LISTRIK'];
  late String dropDownValue = list.first;

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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: "JUMLAH"),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'KATEGORI',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                  value: dropDownValue,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_downward),
                  items: list.map<DropdownMenuItem<String>>((String value) {
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
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Masukkan Tanggal"),
              onTap: () {},
            ),
          ],
        )),
      ),
    );
  }
}
