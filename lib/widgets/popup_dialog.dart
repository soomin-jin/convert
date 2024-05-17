import 'package:flutter/material.dart';
import '../models/stock.dart'; // Stock 클래스를 가져옵니다

class PopupDialog extends StatefulWidget {
  final Stock fromStock;
  final Stock toStock;

  const PopupDialog({
    super.key,
    required this.fromStock,
    required this.toStock,
  });

  @override
  _PopupDialogState createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  double _fromStockCount = 0;
  double _toStockCount = 0;

  double get _fromStockPrice => widget.fromStock.value / widget.fromStock.count;
  double get _toStockPrice => widget.toStock.value / widget.toStock.count;

  void _calculateToStockCount(String value) {
    setState(() {
      _fromStockCount = double.tryParse(value) ?? 0;
      _toStockCount = (_fromStockCount * _fromStockPrice) / _toStockPrice;
      _toController.text = _toStockCount.toStringAsFixed(2);
    });
  }

  void _handleConvert() {
    Navigator.of(context).pop({
      'fromStockCount': _fromStockCount,
      'fromStockValue': _fromStockCount * _fromStockPrice,
      'toStockCount': _toStockCount,
      'toStockValue': _toStockCount * _toStockPrice,
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
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyInputCard(context, "From", _fromController,
                widget.fromStock.name, Icons.account_balance_wallet, true),
            const SizedBox(height: 20),
            const Icon(Icons.swap_vert, size: 40),
            const SizedBox(height: 20),
            _buildCurrencyInputCard(context, "To", _toController,
                widget.toStock.name, Icons.apple, false),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _handleConvert,
              child: const Text(
                "Convert",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      bool isFrom) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: isFrom ? _calculateToStockCount : null,
            decoration: InputDecoration(
              hintText: 'Enter stock count',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currency,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(icon, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
