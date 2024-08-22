import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ThirdTask extends StatefulWidget {
  const ThirdTask({super.key});

  @override
  State<ThirdTask> createState() => _ThirdTaskState();
}

class _ThirdTaskState extends State<ThirdTask> {
  String? pdfFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF with Image Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: generatePdfWithImage,
              child: Text('Generate PDF'),
            ),
            SizedBox(height: 20),
            if (pdfFilePath != null)
              ElevatedButton(
                onPressed: sharePdf,
                child: Text('Share PDF'),
              ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> loadImage(String assetPath) async {
    final AssetImage assetImage = AssetImage(assetPath);
    final ImageStream stream = assetImage.resolve(const ImageConfiguration());
    final Completer<ImageInfo> completer = Completer<ImageInfo>();

    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      }),
    );

    final ImageInfo imageInfo = await completer.future;
    final ByteData? byteData =
    await imageInfo.image.toByteData(format: ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to load image");
    }

    return byteData.buffer.asUint8List();
  }

  Future<void> generatePdfWithImage() async {
    try {
      final pdf = pw.Document();

      final image = pw.MemoryImage(
        await loadImage('assets/th.jpeg'),
      );

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Product Catalog', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Image(image, width: 100, height: 100),
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

      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(await pdf.save());

      setState(() {
        pdfFilePath = file.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF generated and saved successfully")),
      );
    } catch (e) {
      print("Error generating PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate PDF: $e")),
      );
    }
  }

  void sharePdf() {
    if (pdfFilePath != null) {
      Share.shareFiles([pdfFilePath!], text: 'Check out this PDF!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please generate the PDF first!')),
      );
    }
  }
}
