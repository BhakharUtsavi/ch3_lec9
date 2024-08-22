import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class FourTask extends StatefulWidget {
  const FourTask({super.key});

  @override
  State<FourTask> createState() => _FourTaskState();
}

class _FourTaskState extends State<FourTask> {

  String? pdfFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Page PDF Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: generatePdf,
              child: Text('Generate Multi-Page PDF'),
            ),
            SizedBox(height: 20),
            if (pdfFilePath != null)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: printPdf,
                    child: Text('Print PDF'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: sharePdf,
                    child: Text('Share PDF'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    // Cover Page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Cover Page',
              style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold),
            ),
          );
        },
      ),
    );

    // Table of Contents
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Table of Contents',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('1. Introduction', style: pw.TextStyle(fontSize: 18)),
              pw.Text('2. Chapter 1', style: pw.TextStyle(fontSize: 18)),
              pw.Text('3. Chapter 2', style: pw.TextStyle(fontSize: 18)),
              pw.Text('4. Conclusion', style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    // Content Pages
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Introduction', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text(
                'This is the introduction to the report. It provides an overview of the content.',
                style: pw.TextStyle(fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Chapter 1', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text(
                'This is the first chapter. It contains detailed information about the topic.',
                style: pw.TextStyle(fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Chapter 2', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text(
                'This is the second chapter. It continues the discussion with additional details.',
                style: pw.TextStyle(fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Conclusion', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text(
                'This is the conclusion. It summarizes the key points and provides final thoughts.',
                style: pw.TextStyle(fontSize: 18),
              ),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/multi_page_report.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = file.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Multi-page PDF generated successfully")),
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
    if (pdfFilePath != null) {
      Share.shareFiles([pdfFilePath!], text: 'Check out this multi-page PDF!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please generate the PDF first!')),
      );
    }
  }
}
