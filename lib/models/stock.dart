class Stock {
  String name;
  double count;
  double price; // 개당 가격

  Stock({
    required this.name,
    required this.count,
    required this.price,
  });

  double get value => count * price; // 총평가금 계산
}
