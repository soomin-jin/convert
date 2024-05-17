import 'package:flutter/material.dart';
import '../models/stock.dart';

class ConvertScreen extends StatefulWidget {
  final Stock fromStock;
  final List<Stock> stocks;

  const ConvertScreen({
    super.key,
    required this.fromStock,
    required this.stocks,
  });

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  late Stock _fromStock;
  late Stock _toStock;

  @override
  void initState() {
    super.initState();
    _fromStock = widget.fromStock;
    _toStock = widget.stocks.firstWhere((stock) => stock.name == 'USD');
  }

  double get _fromStockPrice => _fromStock.value / _fromStock.count;
  double get _toStockPrice => _toStock.value / _toStock.count;

  void _calculateToStockCount(String value) {
    setState(() {
      double fromStockCount = double.tryParse(value) ?? 0;
      double toStockCount = (fromStockCount * _fromStockPrice) / _toStockPrice;
      _toController.text = toStockCount.toStringAsFixed(2);
    });
  }

  void _handleConvert() {
    Navigator.of(context).pop({
      'fromStockCount': double.tryParse(_fromController.text) ?? 0,
      'fromStockValue':
          (double.tryParse(_fromController.text) ?? 0) * _fromStockPrice,
      'toStockCount': double.tryParse(_toController.text) ?? 0,
      'toStockValue':
          (double.tryParse(_toController.text) ?? 0) * _toStockPrice,
      'toStockName': _toStock.name, // 변환될 주식의 이름도 반환
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Convert Stocks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyInputCard(
                context,
                "From",
                _fromController,
                _fromStock.name,
                Icons.account_balance_wallet,
                true,
                _fromStock),
            const SizedBox(height: 20),
            const Icon(Icons.swap_vert, size: 40, color: Colors.white),
            const SizedBox(height: 20),
            _buildCurrencyInputCard(context, "To", _toController, _toStock.name,
                Icons.apple, false, _toStock),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1B33B),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _handleConvert,
              child: const Text(
                "Convert",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInputCard(
      BuildContext context,
      String label,
      TextEditingController controller,
      String currency,
      IconData icon,
      bool isFrom,
      Stock selectedStock) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          DropdownButton<Stock>(
            value: selectedStock,
            dropdownColor: const Color(0xFF282828),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.grey.shade300,
            ),
            items: widget.stocks.map((Stock stock) {
              return DropdownMenuItem<Stock>(
                value: stock,
                child: Text(stock.name,
                    style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (Stock? newValue) {
              setState(() {
                if (isFrom) {
                  _fromStock = newValue!;
                  _calculateToStockCount(_fromController.text);
                } else {
                  _toStock = newValue!;
                  _calculateToStockCount(_fromController.text);
                }
              });
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: isFrom ? _calculateToStockCount : null,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter stock count',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade600),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currency,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Icon(icon, size: 30, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
