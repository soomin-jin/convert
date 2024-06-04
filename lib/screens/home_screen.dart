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

    List<PieChartSectionData> sections = [
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

    // 내림차순으로 정렬
    sections.sort((a, b) => b.value.compareTo(a.value));

    return sections;
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
    List<PieChartSectionData> sections = _getSections();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6), // 전체 배경색 변경
      appBar: AppBar(
        title: const Text('내 자산', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF4F5F6), // AppBar 배경색 변경
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFFF4F5F6), // 최상단 내자산 부분 색상 변경
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '나의 순자산',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity, // 가로 전체를 차지하도록 설정
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white, // 흰색 배경
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '내 자산이 있는 총 1개의 계좌 합산',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${_formatCurrency(totalBalance)}원',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                          pieTouchData: PieTouchData(enabled: false),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // 도넛 차트와 종목 정보 사이의 여백 추가
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sections.map((section) {
                        return _buildLegendItem(
                          section.title,
                          section.color,
                          _calculatePercentage(section.title),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
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
                    backgroundColor: Colors.white,
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
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
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

  double _calculatePercentage(String title) {
    double value = 0;
    switch (title) {
      case '국내주식':
        value = domesticStocks.fold(0.0, (sum, stock) => sum + stock.value);
        break;
      case '해외주식':
        value =
            internationalStocks.fold(0.0, (sum, stock) => sum + stock.value);
        break;
      case '원화':
        value = cashStocks
            .where((stock) => stock.name == 'KRW')
            .fold(0.0, (sum, stock) => sum + stock.value);
        break;
      case '외화':
        value = cashStocks
            .where((stock) => stock.name == 'USD')
            .fold(0.0, (sum, stock) => sum + stock.value);
        break;
    }
    return (value / totalBalance) * 100;
  }

  Widget _buildLegendItem(String title, Color color, double percentage) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 2), // 퍼센트 정보와 종목 정보 간의 여백 줄임
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8, // 크기를 줄임
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle, // 동그라미 모양으로 변경
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            '${percentage.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
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
              color: Colors.white, // 주식 종목 리스트의 배경색을 흰색으로 설정
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
