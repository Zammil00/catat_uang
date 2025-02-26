import 'package:catat_uang/models/database.dart';
import 'package:catat_uang/models/transaction_with_category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;

  const TransactionPage({super.key, required this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDatabase database = AppDatabase();
  bool isExpanse = true;
  late int type;

  List<String> list = ['MAKAN DAN JAJAN', 'BENSIN', 'KUOTA', 'LISTRIK'];
  late String dropDownValue = list.first;

  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  Category? selectedCategory;

  Future insert(
      int amount, DateTime date, String nameDetail, int categoryId) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.transactions)
        .insertReturning(TransactionsCompanion.insert(
          name: nameDetail,
          category_id: categoryId,
          transaction_date: date,
          amount: amount,
          createdAt: now,
          updatedAt: now,
        ));
    // ignore: avoid_print
    print('APA INI: $row');
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int transactionId, int amount, int categorytransactionId,
      DateTime transactionDate, String nameDetail) async {
    return await database.updateTransactionRepo(transactionId, amount,
        categorytransactionId, transactionDate, nameDetail);
  }

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }

    super.initState();
  }

  void updateTransactionView(TransactionWithCategory transactionWithCategory) {
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    detailController.text = transactionWithCategory.transaction.name;
    dateController.text = DateFormat("yyy-MM-dd")
        .format(transactionWithCategory.transaction.transaction_date);
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpanse = true : isExpanse = false;
    selectedCategory = transactionWithCategory.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Tambah Transaksi",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                    value: isExpanse,
                    onChanged: (bool value) {
                      setState(() {
                        isExpanse = value;
                        type = (isExpanse) ? 2 : 1;
                        selectedCategory = null;
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
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        selectedCategory = (selectedCategory == null)
                            ? snapshot.data!.first
                            : selectedCategory;
                        // ignore: avoid_print
                        print(snapshot.toString());
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButton<Category>(
                            value: (selectedCategory == null)
                                ? snapshot.data!.first
                                : selectedCategory,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_downward),
                            items: snapshot.data!.map((Category item) {
                              return DropdownMenuItem<Category>(
                                value: item,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (Category? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
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
                  onPressed: () async {
                    // Cek apakah ada data yang kosong sebelum menyimpan
                    if (amountController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        detailController.text.isEmpty ||
                        selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Harap isi semua data sebelum menyimpan!'),
                          backgroundColor:
                              Colors.red, // Warna merah untuk error
                        ),
                      );
                      return; // Hentikan eksekusi jika data tidak lengkap
                    }

                    if (widget.transactionWithCategory != null) {
                      await update(
                        widget.transactionWithCategory!.transaction.id,
                        int.parse(amountController.text),
                        selectedCategory!.id,
                        DateTime.parse(dateController.text),
                        detailController.text,
                      );
                    } else {
                      await insert(
                        int.parse(amountController.text),
                        DateTime.parse(dateController.text),
                        detailController.text,
                        selectedCategory!.id,
                      );
                    }

                    setState(() {});

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);

                    // Tampilkan notifikasi berhasil menyimpan
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Transaksi berhasil disimpan!'),
                        backgroundColor:
                            Colors.green, // Warna hijau untuk sukses
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text("Simpan")),
            ),
          ],
        )),
      ),
    );
  }
}
