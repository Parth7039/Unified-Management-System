import 'package:flutter/material.dart';
import 'package:ums/Feature/Invoice/add_invoice.dart';
import 'package:ums/Feature/Invoice/print_invoice.dart';

class BuyerdetailsPage extends StatefulWidget {
  const BuyerdetailsPage({super.key});

  @override
  State<BuyerdetailsPage> createState() => _BuyerdetailsPageState();
}

class _BuyerdetailsPageState extends State<BuyerdetailsPage> {

  final TextEditingController consigneeController = TextEditingController();
  final TextEditingController consignee_add_Controller = TextEditingController();
  final TextEditingController consignee_GST_Controller = TextEditingController();
  final TextEditingController consignee_state_Controller = TextEditingController();

  final TextEditingController buyerController = TextEditingController();
  final TextEditingController buyer_add_Controller = TextEditingController();
  final TextEditingController buyer_GST_Controller = TextEditingController();
  final TextEditingController buyer_state_Controller = TextEditingController();

  final TextEditingController invoicecontroller = TextEditingController();
  final TextEditingController datedcontroller = TextEditingController();
  final TextEditingController dispatchedcontroller = TextEditingController();
  final TextEditingController destinationcontroller = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    consigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        height: 50,
        width: 300,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrintInvoicePage(
              consigneeName: consigneeController.text,
              consigneeAddress: consignee_add_Controller.text,
              consigneeGst: consignee_GST_Controller.text,
              consigneeState: consignee_state_Controller.text,
              buyerName: buyerController.text,
              buyerAddress: buyer_add_Controller.text,
              buyerGst: buyer_GST_Controller.text,
              buyerState: buyer_state_Controller.text,
              invoiceNo: invoicecontroller.text,
              date: datedcontroller.text,
              dispatchedThrough: dispatchedcontroller.text,
              destination: destinationcontroller.text,
            )));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            'Generate Invoice',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddinvoicePage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          'Buyer Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            child: customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  customTextField(label: 'Consignee (Ship to)', hintText: 'Enter consignee Name', controller: consigneeController),
                  customTextField(label: "", hintText: 'Enter Consignee address', controller: consignee_add_Controller),
                  customTextField(label: "", hintText: 'GSTIN/UIN', controller: consignee_GST_Controller),
                  customTextField(label: "", hintText: 'State of supply', controller: consignee_state_Controller),

                  SizedBox(height: 30,),
                  customTextField(label: 'Buyer (Bill to)', hintText: 'Buyer name', controller: buyerController),
                  customTextField(label: "", hintText: 'Enter Buyer address', controller: buyer_add_Controller),
                  customTextField(label: "", hintText: 'GSTIN/UIN', controller: buyer_GST_Controller),
                  customTextField(label: "", hintText: 'Enter Buyer state', controller: buyer_state_Controller),

                ],
              ),
            ),
          ),
          SizedBox(width: 5,),
          Expanded(
              child: customContainer(
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      customTextField(label: 'Invoice No.', hintText: '', controller: invoicecontroller),
                      customTextField(label: 'Dated', hintText: '', controller: datedcontroller),
                      customTextField(label: 'Dispatched through.', hintText: '', controller: dispatchedcontroller),
                      customTextField(label: 'Destination', hintText: '', controller: destinationcontroller),
                    ],
                  ))
          )
        ],
      ),
    );
  }

  // Custom container widget for consistent styling
  Widget customContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  // Custom TextField widget with named parameters
  Widget customTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

}
