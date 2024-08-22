import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class First_Task extends StatefulWidget {
  const First_Task({super.key});

  @override
  State<First_Task> createState() => _First_TaskState();
}

class _First_TaskState extends State<First_Task> {

  Future<void> _generatePdf() async {
    // Create a PDF document.
    final pdf = pw.Document();

    // Load an image from the assets.
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/th.jpeg')).buffer.asUint8List(),
    );

    // Add a page to the PDF.
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('PDF Title', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('This is some basic text in the PDF document.'),
              pw.SizedBox(height: 20),
              pw.Image(image),
            ],
          );
        },
      ),
    );

    // Save the PDF to a file.
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    print('PDF generated and saved at: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generator'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _generatePdf,
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
