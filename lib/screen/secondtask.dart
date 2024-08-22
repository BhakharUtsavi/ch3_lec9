import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SecondTask extends StatefulWidget {
  const SecondTask({super.key});

  @override
  State<SecondTask> createState() => _SecondTaskState();
}

class _SecondTaskState extends State<SecondTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF with Image Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generatePdfWithImage,
          child: Text('Generate PDF'),
        ),
      ),
    );
  }

  // Future<Uint8List> loadAsset(String path) async {
  //   final ByteData data = await rootBundle.load(path);
  //   return data.buffer.asUint8List();
  // }

  Future<void> generatePdfWithImage() async {
    final pdf = pw.Document();

    // final image = pw.MemoryImage(
    //   await loadAsset('assets/th.jpeg'),
    // );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Product Catalog', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Center(
                //child: pw.Image(image, width: 100, height: 100),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Product 1', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Description of Product 1'),
              pw.SizedBox(height: 20),
              pw.Text('Product 2', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Description of Product 2'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
