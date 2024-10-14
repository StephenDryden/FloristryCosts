import 'package:floristry_costs/bill.dart';
import 'package:floristry_costs/item.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  CalculatorPageState createState() => CalculatorPageState();
}

class CalculatorPageState extends State<CalculatorPage> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  static double vat = 20.0;
  static double labour = 20.0;
  static int multiplier = 2;
  static double totalPrice = 0.00;
  late Bill bill = Bill([], vat, labour, multiplier, totalPrice);

  void _addItem() {
    setState(() {
      // Create new item and add to items
      String name = _itemNameController.text;
      int quantity = int.parse(_quantityController.text);
      double price = double.parse(_priceController.text);
      double total = quantity * price;

      Item item = Item(name, quantity, price, total);

      bill.items.add(item);

      // Clear text fields after adding
      _itemNameController.clear();
      _quantityController.clear();
      _priceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 5.0),
            Expanded(
              // Item
              child: Text("Item"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Quantiy
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 30.0,
                    child: Text("QTY"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: Text("Cost"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                      width: 50.0, // Adjust width as needed
                      child: Text("Add")),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Expanded(
              // Item
              child: TextField(
                decoration: InputDecoration(hintText: "Enter Item Name"),
                controller: _itemNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Quantiy
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 30.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _priceController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                  // Add button
                  children: [
                    SizedBox(width: 5.0),
                    ElevatedButton(onPressed: _addItem, child: Icon(Icons.add)),
                  ]),
            ),
          ],
        ),
        Row(
          children: [SizedBox(width: 5.0), Text("Items")],
        ),
        Row(
          children: [
            bill.items.isEmpty
                ? Center(child: Text('No items found'))
                : ListView.builder(
                    itemCount: bill.items.length,
                    itemBuilder: (context, index) {
                      final item = bill.items[index];
                      return ListTile(
                        title: Text(item.name),
                      );
                    },
                  )
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("VAT: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller:
                          TextEditingController(text: bill.vat.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          bill.vat = double.parse(value);
                          bill.updateTotalCost();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Labour: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller:
                          TextEditingController(text: bill.labour.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          bill.labour = double.parse(value);
                          bill.updateTotalCost();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Multiplier: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController(
                          text: bill.multiplier.toString()),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          bill.multiplier = int.parse(value);
                          bill.updateTotalCost();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 5.0),
            Text("Total Cost: "),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                // Price
                children: [
                  SizedBox(width: 5.0),
                  SizedBox(
                    width: 50.0, // Adjust width as needed
                    child: Text(bill.totalPrice.toStringAsFixed(2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
