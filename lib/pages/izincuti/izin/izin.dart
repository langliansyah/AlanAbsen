import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import DateFormat from intl package

class IzinPage extends StatefulWidget {
  final bool showIzin;
  const IzinPage({super.key, this.showIzin = false});

  @override
  _IzinPageState createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  File? _image;
  String _selectedJenisIzin = 'WFH';
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

  final picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
      }
    });
  }

  void _showImagePreviewDialog(String imagePath) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Preview Gambar'),
          content: Image.network(imagePath),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                setState(() {
                  _image = null;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey,
        style: BorderStyle.solid,
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Izin'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jenis Izin',
                      hintText: 'Pilih Jenis Izin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.article),
                    ),
                    value: _selectedJenisIzin,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedJenisIzin = newValue!;
                      });
                    },
                    items: <String>['WFH', 'Sakit', 'Izin Lainnya'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _tanggalController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Izin',
                      hintText: 'Masukkan Tanggal Izin',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            
                            setState(() {
                              _tanggalController.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _alasanController,
                    decoration: const InputDecoration(
                      labelText: 'Alasan',
                      hintText: 'Masukkan Alasan Izin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.text_snippet),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20.0),
                  _image == null
                      ? MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: _containerDecoration(),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                  ),
                                  Text(
                                    'Tap to take a picture',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (kIsWeb) {
                              _showImagePreviewDialog(_image!.path);
                            } else {
                              _showImagePreviewDialog(_image! as String);
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: kIsWeb
                                ? Image.network(
                                    _image!.path,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  )
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Logic to submit the form
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
