import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockPicker extends StatelessWidget {
  final List<Stock> stocks;
  final bool isFrom;
  final Function(Stock) onStockSelected;

  const StockPicker({
    super.key,
    required this.stocks,
    required this.isFrom,
    required this.onStockSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                labelText: '검색 후 교환할 종목을 선택해 주세요.',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                final stock = stocks[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      stock.name[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(stock.name),
                  trailing: const Text('보유'),
                  onTap: () {
                    onStockSelected(stock);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
