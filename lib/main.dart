import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/stock.dart';
import 'screens/convert_screen.dart';
import 'widgets/button.dart';
import 'widgets/currency_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double totalBalance = 274936;
  int selectedIndex = -1;

  List<Stock> stocks = [
    Stock(name: '삼성전자', count: 1842.05, value: 102234),
    Stock(name: '애플', count: 380.45, value: 72234),
    Stock(name: 'USD', count: 60234, value: 60234),
    Stock(name: 'KRW', count: 56327600, value: 40234),
  ];

  @override
  void initState() {
    super.initState();
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(value);
  }

  void _handleCardTap(int index) {
    setState(() {
      selectedIndex = (selectedIndex == index) ? -1 : index;
    });
  }

  void _navigateToConvertScreen(BuildContext context, Stock fromStock) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ConvertScreen(fromStock: fromStock, stocks: stocks),
      ),
    );

    if (result != null) {
      setState(() {
        fromStock.count -= result['fromStockCount']!;
        fromStock.value -= result['fromStockValue']!;
        Stock toStock =
            stocks.firstWhere((stock) => stock.name == result['toStockName']);
        toStock.count += result['toStockCount']!;
        toStock.value += result['toStockValue']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Hello, Zimmy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Text(
                'Total balance',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '\$ ${_formatCurrency(totalBalance)}',
                style: TextStyle(
                    fontSize: 42,
                    color: Colors.white.withOpacity(1),
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      text: 'Deposit',
                      bgColor: Color(0xFFF1B33B),
                      textColor: Colors.black,
                      width: 180, // 고정된 너비 설정
                    ),
                    Button(
                      text: 'Withdraw',
                      bgColor: Color.fromARGB(255, 70, 75, 80),
                      textColor: Colors.white,
                      width: 180, // 고정된 너비 설정
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wallets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: stocks.asMap().entries.map((entry) {
                  int index = entry.key;
                  Stock stock = entry.value;
                  return Column(
                    children: [
                      CurrencyCard(
                        name: stock.name,
                        amount: stock.count.toStringAsFixed(2),
                        value: _formatCurrency(stock.value),
                        icon: Icons.euro_rounded,
                        isInverted: false,
                        isSelected: selectedIndex == index,
                        onTap: () => _handleCardTap(index),
                        showPopup: () =>
                            _navigateToConvertScreen(context, stock),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
