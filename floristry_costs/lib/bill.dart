import "package:floristry_costs/item.dart";

class Bill {
  List<Item> items;
  double vat;
  double labour;
  int multiplier;
  double totalPrice;

  Bill(this.items, this.vat, this.labour, this.multiplier, this.totalPrice);

  void updateTotalCost() {
    double totalItemsPrice = 0;

    for (Item item in items) {
      totalItemsPrice += item.total;
    }
    totalPrice =
        totalItemsPrice * (1 + vat / 100) * (1 + labour / 100) * multiplier;
  }
}
