import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Stock selectedStock;
  final bool isFrom;
  final Function() showStockPicker;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const StockCard({
    super.key,
    required this.label,
    required this.controller,
    required this.selectedStock,
    required this.isFrom,
    required this.showStockPicker,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showStockPicker,
      child: Container(
        height: 170,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    '${selectedStock.count.toStringAsFixed(4)} 주',
                    style: const TextStyle(
                      color: Color(0xFF949494),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      selectedStock.name[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 17),
                  child: Text(
                    selectedStock.name,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  margin: const EdgeInsets.only(top: 17),
                  child: const Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 40,
                      child: TextField(
                        focusNode: focusNode,
                        textAlign: TextAlign.right,
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        ),
                        onTap: () {
                          if (controller.text == '0') {
                            controller.clear();
                          }
                        },
                        onChanged: onChanged,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (isFrom)
                      GestureDetector(
                        onTap: () {
                          controller.text =
                              selectedStock.count.toStringAsFixed(4);
                          onChanged(controller.text);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20.0, top: 3),
                          child: Text(
                            '최대',
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
