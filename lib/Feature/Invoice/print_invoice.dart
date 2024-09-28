import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ums/Feature/Invoice/buyer_details.dart';
import 'package:flutter/rendering.dart'; // For capturing widget as image
import 'package:path_provider/path_provider.dart'; // To get the temp directory
import 'dart:ui' as ui;

class PrintInvoicePage extends StatefulWidget {

  final String consigneeName;
  final String consigneeAddress;
  final String consigneeGst;
  final String consigneeState;
  final String buyerName;
  final String buyerAddress;
  final String buyerGst;
  final String buyerState;
  final String invoiceNo;
  final String date;
  final String dispatchedThrough;
  final String destination;

  PrintInvoicePage({
    super.key,
    required this.consigneeName,
    required this.consigneeAddress,
    required this.consigneeGst,
    required this.consigneeState,
    required this.buyerName,
    required this.buyerAddress,
    required this.buyerGst,
    required this.buyerState,
    required this.invoiceNo,
    required this.date,
    required this.dispatchedThrough,
    required this.destination,
  });

  @override
  State<PrintInvoicePage> createState() => _PrintInvoicePageState();
}

class _PrintInvoicePageState extends State<PrintInvoicePage> {
  final GlobalKey _printKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BuyerdetailsPage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Preview Invoice',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: Colors.black),
            onPressed: () => _generateAndOpenPdf(),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _printKey, // Key for capturing
        child: Column(
          children: [
            customContainer(
              Text(
                  'K B ELECTRIC COMPANY \n11 DEEPLAXMI CHS,MOHINDAR HIGHSCHOOL ROAD \nAGRA ROAD KALYAN WEST \nDIST: THANE \nState Name: Maharashtra, Code:27 \nE-mail: kbeco.2001@gmail.com'
              ),
            ),
            customContainer(
                Text('${widget.consigneeName}\n${widget.consigneeAddress}\nGSTIN/UIN: ${widget.consigneeGst}\nState: ${widget.consigneeState}')
            ),
            customContainer(
              Text('data')
            )
          ],
        ),
      ),
    );
  }

  Widget customContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: child,
    );
  }

  Future<void> _generateAndOpenPdf() async {
    try {
      // Convert the widget to an image
      final imageBytes = await _capturePng();

      // Create a PDF document
      final pdf = pw.Document();

      // Add the image to the PDF document
      final image = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );

      // Get the temporary directory and save the PDF
      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/invoice.pdf");

      await file.writeAsBytes(await pdf.save());

      // Open the PDF file depending on the platform
      if (Platform.isWindows) {
        Process.run('start', [file.path], runInShell: true);
      } else if (Platform.isLinux) {
        Process.run('xdg-open', [file.path]);
      } else if (Platform.isMacOS) {
        Process.run('open', [file.path]);
      }
    } catch (e) {
      print("Error generating or opening PDF: $e");
    }
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print("Error capturing widget as image: $e");
      throw e;
    }
  }
}
