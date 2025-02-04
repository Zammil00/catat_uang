import 'package:catat_uang/models/database.dart';
import 'package:catat_uang/models/transaction_with_category.dart';
// import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CONTAINER INCOME DAN EXPENSE
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
                          Icons.download,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Rp. 3.800.000",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(
                          Icons.upload,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expanse",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Rp. 3.800.000",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          // TEXT TRANSAKSI
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "TRANSAKSI",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          StreamBuilder<List<TransactionWithCategory>>(
            stream: database.getTransactionByDateRepo(widget.selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, Index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.edit),
                                ],
                              ),
                              title: Text("Rp. 20.000"),
                              subtitle: Text("Makan Siang"),
                              leading: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Icon(
                                  Icons.upload,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('Data Transaksi Kosong'),
                    );
                  }
                } else {
                  return Center(
                    child: Text('Tidak Ada Data'),
                  );
                }
              }
            },
          ),

          // LIST TRANSAKSI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.edit),
                  ],
                ),
                title: Text("Rp. 20.000"),
                subtitle: Text("Makan Siang"),
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Icon(
                    Icons.upload,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.edit),
                  ],
                ),
                title: Text("Rp. 20.000.000"),
                subtitle: Text("Gaji Bulanan"),
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Icon(
                    Icons.download,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
