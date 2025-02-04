// ignore_for_file: unused_import, duplicate_import, non_constant_identifier_names, prefer_is_empty

import 'package:catat_uang/models/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpanse = true;

  int type = 2;

  final AppDatabase database = AppDatabase();

  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final Row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    // ignore: avoid_print
    print(Row);
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(int categoryid, String newName) async {
    return await database.updateCategoryRepo(categoryid, newName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      (isExpanse) ? "Tambah Pengeluaran" : "Tambah Pemasukan",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: (isExpanse) ? Colors.red : Colors.green),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (category == null) {
                            insert(
                                categoryNameController.text, isExpanse ? 2 : 1);
                          } else {
                            update(category.id, categoryNameController.text);
                          }

                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          setState(() {});
                          categoryNameController.clear();
                        },
                        child: Text("Simpan")),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpanse,
                  onChanged: (bool value) {
                    setState(() {
                      isExpanse = value;
                      type = value ? 2 : 1;
                    });
                  },
                  inactiveTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                    onPressed: () {
                      openDialog(null);
                    },
                    icon: Icon(Icons.add))
              ],
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
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, Index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  leading: (isExpanse)
                                      ? Icon(
                                          Icons.upload,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.download,
                                          color: Colors.green,
                                        ),
                                  title: Text(snapshot.data![Index].name),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            database.deleteCategoryRepo(
                                                snapshot.data![Index].id);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete)),
                                      IconButton(
                                          onPressed: () {
                                            openDialog(snapshot.data![Index]);
                                          },
                                          icon: Icon(Icons.edit)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text('Tidak Ada Data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Tidak Ada Data'),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
