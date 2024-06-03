import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';
import 'convert_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Stock> stocks;

  const HomeScreen({
    super.key,
    required this.stocks,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Stock> domesticStocks;
  late List<Stock> internationalStocks;
  late List<Stock> cashStocks;
  late double totalBalance;

  @override
  void initState() {
    super.initState();
    _categorizeStocks();
    totalBalance = _calculateTotalBalance();
  }

  void _categorizeStocks() {
    domesticStocks =
        widget.stocks.where((stock) => stock.name == '삼성전자').toList();
    internationalStocks =
        widget.stocks.where((stock) => stock.name == '애플').toList();
    cashStocks = widget.stocks
        .where((stock) => stock.name == 'USD' || stock.name == 'KRW')
        .toList();
  }

  double _calculateTotalBalance() {
    return widget.stocks.fold(0, (sum, stock) => sum + stock.value);
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat('#,##0'); // 소수점 이하 자릿수를 없앰
    return formatter.format(value);
  }

  List<PieChartSectionData> _getSections() {
    final domesticValue =
        domesticStocks.fold(0.0, (sum, stock) => sum + stock.value);
    final internationalValue =
        internationalStocks.fold(0.0, (sum, stock) => sum + stock.value);
    final krwValue = cashStocks
        .where((stock) => stock.name == 'KRW')
        .fold(0.0, (sum, stock) => sum + stock.value);
    final usdValue = cashStocks
        .where((stock) => stock.name == 'USD')
        .fold(0.0, (sum, stock) => sum + stock.value);

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: domesticValue,
        title: '국내주식',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: internationalValue,
        title: '해외주식',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: krwValue,
        title: '원화',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: usdValue,
        title: '외화',
        radius: 50,
      ),
    ];
  }

  void _navigateToConvertScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConvertScreen(fromStock: widget.stocks[0], stocks: widget.stocks),
      ),
    );

    if (result != null) {
      setState(() {
        // 교환 결과에 따라 stocks 목록을 갱신합니다.
        final fromStock = widget.stocks
            .firstWhere((stock) => stock.name == result['fromStockName']);
        final toStock = widget.stocks
            .firstWhere((stock) => stock.name == result['toStockName']);
        fromStock.count = result['fromStockCount'];
        toStock.count = result['toStockCount'];
        totalBalance = _calculateTotalBalance();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('내 자산', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '나의 순자산',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${_formatCurrency(totalBalance)}원',
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.5,
                child: PieChart(
                  PieChartData(
                    sections: _getSections(),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(enabled: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 매도 바로받기 버튼 클릭 시 동작
                  },
                  icon: const Icon(Icons.attach_money),
                  label: const Text('매도 바로받기'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFFF7F8F9),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToConvertScreen,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('교환 바로받기'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildStockCategory('국내 주식', domesticStocks),
              _buildStockCategory('해외 주식', internationalStocks),
              _buildStockCategory('예수금', cashStocks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockCategory(String title, List<Stock> stocks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
          children: stocks.map((stock) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(stock.name[0]),
                ),
                title: Text(stock.name),
                subtitle: Text('보유 수량: ${stock.count.toStringAsFixed(2)}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_formatCurrency(stock.value)}원',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_formatCurrency(stock.price)}원/주', // 개당 가격도 원 단위로 표시
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
