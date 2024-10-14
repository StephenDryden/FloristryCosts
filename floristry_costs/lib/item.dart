class Item {
  String name;
  int quantity;
  double price;
  double total;

  Item(this.name, this.quantity, this.price, this.total);

  void calculateTotal() {
    total = price * quantity;
  }
}
