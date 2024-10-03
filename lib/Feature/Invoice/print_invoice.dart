import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ums/Feature/Invoice/buyer_details.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
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
  final List<Map<String, String>> addedItems;

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
    required this.addedItems,
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
              MaterialPageRoute(builder: (context) => BuyerdetailsPage(addedItems: [])),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Tax Invoice Preview',
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
        key: _printKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildSectionTitle('Consignee (Ship to)'),
              _buildConsigneeDetails(),
              SizedBox(height: 20),
              _buildSectionTitle('Buyer (Bill to)'),
              _buildBuyerDetails(),
              SizedBox(height: 20),
              _buildSectionTitle('Item Details'),
              _buildItemTable(),
              SizedBox(height: 20),
              _buildSectionTitle('Tax Details'),
              _buildTaxTable(),
              SizedBox(height: 20),
              _buildTotalSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: customContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'K B ELECTRIC COMPANY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '11 DEEPLAXMI CHS, MOHINDAR HIGHSCHOOL ROAD,\nAGRA ROAD KALYAN WEST, DIST: THANE',
                  style: TextStyle(fontSize: 12),
                ),
                Text('State: Maharashtra, Code: 27', style: TextStyle(fontSize: 12)),
                Text('E-mail: kbeco.2001@gmail.com', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        Expanded(
          child: customContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice No: ${widget.invoiceNo}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Date: ${widget.date}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Dispatched Through: ${widget.dispatchedThrough}', style: TextStyle(fontSize: 12)),
                Text('Destination: ${widget.destination}', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
    );
  }

  Widget _buildConsigneeDetails() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.consigneeName}'),
          Text('${widget.consigneeAddress}'),
          Text('GSTIN/UIN: ${widget.consigneeGst}'),
          Text('State: ${widget.consigneeState}'),
        ],
      ),
    );
  }

  Widget _buildBuyerDetails() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.buyerName}'),
          Text('${widget.buyerAddress}'),
          Text('GSTIN/UIN: ${widget.buyerGst}'),
          Text('State: ${widget.buyerState}'),
        ],
      ),
    );
  }

  Widget _buildItemTable() {
    return customContainer(
      Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              _buildTableHeaderRow(['Item', 'Quantity', 'Price', 'Total']),
              ...widget.addedItems.map((item) {
                return _buildTableRow([
                  item['name'] ?? 'N/A',
                  item['quantity'] ?? '0',
                  '\$${item['price'] ?? '0'}',
                  '\$${(int.parse(item['quantity'] ?? '0') * double.parse(item['price'] ?? '0')).toString()}',
                ]);
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaxTable() {
    return customContainer(
      Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              _buildTableHeaderRow(['Tax Type', 'Rate', 'Amount']),
              _buildTableRow(['CGST', '9%', '\$9']),
              _buildTableRow(['SGST', '9%', '\$9']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$118 (Including Taxes)'),
        ],
      ),
    );
  }

  TableRow _buildTableHeaderRow(List<String> headers) {
    return TableRow(
      children: headers.map((header) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell),
        );
      }).toList(),
    );
  }

  Widget customContainer(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Future<void> _generateAndOpenPdf() async {
    try {
      final pdf = pw.Document();

      // Add the header
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('K B ELECTRIC COMPANY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                        pw.Text('11 DEEPLAXMI CHS, MOHINDAR HIGHSCHOOL ROAD,\nAGRA ROAD KALYAN WEST, DIST: THANE', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('State: Maharashtra, Code: 27', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('E-mail: kbeco.2001@gmail.com', style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice No: ${widget.invoiceNo}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Date: ${widget.date}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('Dispatched Through: ${widget.dispatchedThrough}', style: pw.TextStyle(fontSize: 12)),
                        pw.Text('Destination: ${widget.destination}', style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Consignee Details
                pw.Text('Consignee (Ship to)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text('${widget.consigneeName}'),
                pw.Text('${widget.consigneeAddress}'),
                pw.Text('GSTIN/UIN: ${widget.consigneeGst}'),
                pw.Text('State: ${widget.consigneeState}'),
                pw.SizedBox(height: 20),

                // Buyer Details
                pw.Text('Buyer (Bill to)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text('${widget.buyerName}'),
                pw.Text('${widget.buyerAddress}'),
                pw.Text('GSTIN/UIN: ${widget.buyerGst}'),
                pw.Text('State: ${widget.buyerState}'),
                pw.SizedBox(height: 20),

                // Item Details Table
                pw.Text('Item Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...widget.addedItems.map((item) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['name'] ?? 'N/A'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['quantity'] ?? '0'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('\$${item['price'] ?? '0'}'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('\$${(int.parse(item['quantity'] ?? '0') * double.parse(item['price'] ?? '0')).toString()}'),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Tax Details Table
                pw.Text('Tax Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Tax Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Rate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('CGST'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('9%'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('\$9'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('SGST'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('9%'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('\$9'),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Total Amount
                pw.Text('Total Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text('\$118 (Including Taxes)'),
              ],
            );
          },
        ),
      );

      // Save the PDF
      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/invoice.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
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
