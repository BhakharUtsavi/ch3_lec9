import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class FifthTask extends StatefulWidget {
  const FifthTask({super.key});

  @override
  State<FifthTask> createState() => _FifthTaskState();
}

class _FifthTaskState extends State<FifthTask> {
  final List<Map<String, String>> products = [
    {'name': 'Product 1', 'description': 'Description of Product 1'},
    {'name': 'Product 2', 'description': 'Description of Product 2'},
    {'name': 'Product 3', 'description': 'Description of Product 3'},
    {'name': 'Product 4', 'description': 'Description of Product 4'},
  ];

  final List<Map<String, String>> selectedProducts = [];

  String? pdfFilePath;

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Product Catalog',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              ...selectedProducts.map(
                    (product) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      product['name']!,
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(product['description']!),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/product_catalog.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = file.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF catalog generated successfully")),
    );
  }

  void printPdf() {
    if (pdfFilePath != null) {
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          final file = File(pdfFilePath!);
          return file.readAsBytesSync();
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please generate the PDF first!')),
      );
    }
  }

  void sharePdf() {
    if (pdfFilePath != null && pdfFilePath!.isNotEmpty) {
      Share.shareFiles([pdfFilePath!], text: 'Check out this product catalog!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File path is empty or invalid.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Catalog Generator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isSelected = selectedProducts.contains(product);
                return ListTile(
                  title: Text(product['name']!),
                  subtitle: Text(product['description']!),
                  trailing: Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isSelected ? Colors.green : null,
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedProducts.remove(product);
                      } else {
                        selectedProducts.add(product);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedProducts.isNotEmpty ? generatePdf : null,
              child: Text('Generate PDF Catalog'),
            ),
          ),
          if (pdfFilePath != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: printPdf,
                child: Text('Print PDF'),
              ),
            ),
          if (pdfFilePath != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: sharePdf,
                child: Text('Share PDF'),
              ),
            ),
        ],
      ),
    );
  }
}
