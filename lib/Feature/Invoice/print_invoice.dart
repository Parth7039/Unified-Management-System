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
  final double? totalAmount;

  const PrintInvoicePage({
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
    this.totalAmount,
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
              MaterialPageRoute(
                builder: (context) => BuyerdetailsPage(
                  addedItems: const [],
                  totalAmount: widget.totalAmount ?? 0.0, // Handle null case with default value
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Tax Invoice Preview',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.black),
            onPressed: () => _generateAndOpenPdf(),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _printKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSectionTitle('Consignee (Ship to)'),
              _buildConsigneeDetails(),
              const SizedBox(height: 20),
              _buildSectionTitle('Buyer (Bill to)'),
              _buildBuyerDetails(),
              const SizedBox(height: 20),
              _buildSectionTitle('Item Details'),
              _buildItemTable(),
              const SizedBox(height: 20),
              _buildSectionTitle('Tax Details'),
              _buildTaxTable(),
              const SizedBox(height: 20),
              _buildTotalSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Build Header Section
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: customContainer(
            const Column(
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
                Text('Invoice No: ${widget.invoiceNo}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Date: ${widget.date}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Dispatched Through: ${widget.dispatchedThrough}', style: const TextStyle(fontSize: 12)),
                Text('Destination: ${widget.destination}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
    );
  }

  // Build Consignee Details
  Widget _buildConsigneeDetails() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.consigneeName),
          Text(widget.consigneeAddress),
          Text('GSTIN/UIN: ${widget.consigneeGst}'),
          Text('State: ${widget.consigneeState}'),
        ],
      ),
    );
  }

  // Build Buyer Details
  Widget _buildBuyerDetails() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.buyerName),
          Text(widget.buyerAddress),
          Text('GSTIN/UIN: ${widget.buyerGst}'),
          Text('State: ${widget.buyerState}'),
        ],
      ),
    );
  }

  // Build Item Table
  Widget _buildItemTable() {
    return customContainer(
      Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              _buildTableHeaderRow(['Description', 'HSN', 'Rate', 'Quantity', 'Total']),
              ...widget.addedItems.map((item) {
                return _buildTableRow([
                  item['description'] ?? 'N/A',
                  item['hsn'] ?? '0',
                  item['rate'] ?? '0',
                  item['quantity'] ?? '0',
                  '\$${(int.parse(item['quantity'] ?? '0') * double.parse(item['rate'] ?? '0')).toString()}',
                ]);
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Build Tax Table
  Widget _buildTaxTable() {
    double totalTax = widget.totalAmount! * 0.18;
    double cgst = totalTax / 2;
    double sgst = totalTax / 2;

    return customContainer(
      Column(
        children: [
          Table(
            border: TableBorder.all(),
            children: [
              _buildTableHeaderRow(['Tax Type', 'Rate', 'Amount']),
              _buildTableRow(['CGST', '9%', '\$$cgst']),
              _buildTableRow(['SGST', '9%', '\$$sgst']),
            ],
          ),
        ],
      ),
    );
  }

  // Build Total Section
  Widget _buildTotalSection() {
    return customContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\$${widget.totalAmount?.toStringAsFixed(2)} (Including Taxes)'),
        ],
      ),
    );
  }

  // Table Row Builder
  TableRow _buildTableHeaderRow(List<String> headers) {
    return TableRow(
      children: headers.map((header) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(header, style: const TextStyle(fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  // Table Data Row Builder
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

  // Custom Container for Styling
  Widget customContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
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

      // Calculate total amount for the items
      double totalAmount = widget.addedItems.fold(0, (sum, item) {
        int quantity = int.tryParse(item['quantity'] ?? '0') ?? 0;
        double rate = double.tryParse(item['rate'] ?? '0') ?? 0;
        return sum + (quantity * rate);
      });

      // Calculate tax amounts
      double cgstAmount = totalAmount * 0.09;
      double sgstAmount = totalAmount * 0.09;
      double totalWithTax = totalAmount + cgstAmount + sgstAmount;

      // Add the content and footer
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('K B ELECTRIC COMPANY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                        pw.Text(
                          '11 DEEPLAXMI CHS, MOHINDAR HIGHSCHOOL ROAD,\nAGRA ROAD KALYAN WEST, DIST: THANE',
                          style: pw.TextStyle(fontSize: 12),
                        ),
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
                pw.Text(widget.consigneeName),
                pw.Text(widget.consigneeAddress),
                pw.Text('GSTIN/UIN: ${widget.consigneeGst}'),
                pw.Text('State: ${widget.consigneeState}'),
                pw.SizedBox(height: 20),

                // Buyer Details
                pw.Text('Buyer (Bill to)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text(widget.buyerName),
                pw.Text(widget.buyerAddress),
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
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('HSN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Rate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8.0),
                          child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...widget.addedItems.map((item) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['description'] ?? 'N/A'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['hsn'] ?? 'N/A'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(item['quantity'] ?? '0'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('R ${item['rate'] ?? '0'}'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('Rs ${(int.parse(item['quantity'] ?? '0') * double.parse(item['rate'] ?? '0')).toString()}'),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 10),

                // Display Total Amount after item table
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Total Amount: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.Text('Rs ${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14)),
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
                          child: pw.Text('Rs ${cgstAmount.toStringAsFixed(2)}'),
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
                          child: pw.Text('Rs ${sgstAmount.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Total Amount with taxes
                pw.Text('Total Amount: Rs ${totalWithTax.toStringAsFixed(2)} (Including Taxes)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),

                pw.SizedBox(height: 20), // Space before footer

                // Add the footer with company name and signature
                pw.Spacer(), // Pushes the footer to the bottom
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('K B Electric Company', style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 30),
                        pw.Text('Signature', style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save the PDF
      final tempDir = await getTemporaryDirectory();
      final file = File("${tempDir.path}/invoice.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open the PDF based on platform
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
      rethrow;
    }
  }
}
