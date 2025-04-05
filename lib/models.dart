class ACCOUNT {
  String name;
  String? phone;
  String password;
  ACCOUNT(this.name, this.password);
  void addPhone(String phone){
    this.phone=phone;
  }
}
List<ACCOUNT> accounts = [];
class Data {
  String item;
  double price;
  int number;
  String? name;
  Data(this.item, this.price, this.number, this.name);
}
List<Data> col = [];