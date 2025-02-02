import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpanse = true;

  void openDialog() {
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
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Tambah")),
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
                    });
                  },
                  inactiveTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                    onPressed: () {
                      openDialog();
                    },
                    icon: Icon(Icons.add))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                title: Text("Sedekah"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
