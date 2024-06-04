import 'package:flutter/material.dart';
import 'models/stock.dart';
import 'screens/home_screen.dart';

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
  List<Stock> stocks = [
    Stock(name: '삼성전자', count: 1842.05, price: 73000),
    Stock(name: '애플', count: 380.45, price: 230000),
    Stock(name: 'USD', count: 60234, price: 1386),
    Stock(name: 'KRW', count: 56327600, price: 1),
  ];

  int _selectedIndex = 2; // 세 번째 탭이 초기 활성화된 탭

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: '내 자산',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '더보기',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 2:
        return HomeScreen(stocks: stocks);
      default:
        return const Center(
          child: Text(
            '탭을 사용할 수 없습니다',
            style: TextStyle(fontSize: 24),
          ),
        );
    }
  }
}
