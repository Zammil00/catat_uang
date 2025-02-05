import 'package:catat_uang/models/database.dart';
import 'package:catat_uang/models/transaction_with_category.dart';
import 'package:catat_uang/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();
  double totalIncome = 0;
  double totalExpense = 0;

  void _refreshTransactions() {
    _calculateTotals();
  }

  void _calculateTotals() async {
    // Await the Future and then cast the result to double
    int income = await database.getTotalIncomeByMonth(widget.selectedDate);
    int expense = await database.getTotalExpenseByMonth(widget.selectedDate);

    setState(() {
      totalIncome = income.toDouble(); // Convert the integer to double
      totalExpense = expense.toDouble(); // Convert the integer to double
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

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
                        SizedBox(width: 15),
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
                            SizedBox(height: 10),
                            Text(
                              "Rp. ${NumberFormat('#,##0', 'id_ID').format(totalIncome)}",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
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
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expense",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Rp. ${NumberFormat('#,##0', 'id_ID').format(totalExpense)}",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // TEXT TRANSAKSI
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TRANSAKSI",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _refreshTransactions();
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),

            StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await database.deleteTransactionRepo(
                                          snapshot.data![Index].transaction.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Data berhasil dihapus!'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      _refreshTransactions();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => TransactionPage(
                                          transactionWithCategory:
                                              snapshot.data![Index],
                                        ),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                              title: Text(
                                "Rp. ${NumberFormat('#,##0', 'id_ID').format(snapshot.data![Index].transaction.amount)}",
                              ),
                              subtitle: Text(
                                "${snapshot.data![Index].category.name}  [${snapshot.data![Index].transaction.name}]",
                              ),
                              leading: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child:
                                    (snapshot.data![Index].category.type == 2)
                                        ? Icon(
                                            Icons.upload,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.download,
                                            color: Colors.green,
                                          ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Data Transaksi Kosong'));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
