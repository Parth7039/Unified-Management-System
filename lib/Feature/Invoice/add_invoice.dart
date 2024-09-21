import 'package:flutter/material.dart';

class AddinvoicePage extends StatefulWidget {
  const AddinvoicePage({super.key});

  @override
  State<AddinvoicePage> createState() => _AddinvoicePageState();
}

class _AddinvoicePageState extends State<AddinvoicePage> {

  TextEditingController Desccontroller = TextEditingController();
  TextEditingController quantitycontroller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [

          Expanded(child: customContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Add Item',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                ),
                customTextField('Description', 'Enter product Description', controller: Desccontroller),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customTextField('Quantity', 'Enter quantity', controller: quantitycontroller),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: customTextField('Rate', 'Enter Rate', controller: ratecontroller),
                    ),
                  ],
                ),
              ],
            )
          )),

          Expanded(child: customContainer(
              Text('Add Item',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
          )),

        ],
      ),
    );
  }

  Widget customTextField(
      String label,
      String hintText, {
        required TextEditingController controller,
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        Container(
          width: MediaQuery.of(context).size.width * 0.222, // 40% of screen width
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: isPassword ? Icon(Icons.lock, color: Colors.black) : null,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  // Toggle password visibility (if needed)
                  controller.text.isEmpty ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Implement visibility toggle if needed
                },
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget customContainer(Widget def_child){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: def_child,
      ),
    );
  }

}
