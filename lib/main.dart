import 'package:flutter/material.dart';
import 'package:toonflix/widgets/button.dart';
import 'package:toonflix/widgets/currency_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 120,
                ),
                Text(
                  'Total balance',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  '\$ 312,873',
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
                          text: 'Transfer',
                          bgColor: Color(0xFFF1B33B),
                          textColor: Colors.black),
                      Button(
                          text: 'Request',
                          bgColor: Color.fromARGB(255, 70, 75, 80),
                          textColor: Colors.white)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wallets',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      Text('View All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ]),
                const SizedBox(
                  height: 20,
                ),
                const CurrencyCard(
                  name: '삼성전자',
                  amount: '6.342',
                  value: '102,234',
                  icon: Icons.euro_rounded,
                  isInverted: false,
                ),
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: const CurrencyCard(
                    name: '애플',
                    amount: '3.235',
                    value: '72,234',
                    icon: Icons.euro_rounded,
                    isInverted: true,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: const CurrencyCard(
                    name: 'USD',
                    amount: '6.342',
                    value: '60,234',
                    icon: Icons.euro_rounded,
                    isInverted: false,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: const CurrencyCard(
                    name: 'KRW',
                    amount: '14.24',
                    value: '40,234',
                    icon: Icons.euro_rounded,
                    isInverted: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
