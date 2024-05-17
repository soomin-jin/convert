import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, amount, value;
  final IconData icon;
  final bool isInverted;
  final bool isSelected;
  final VoidCallback onTap;

  const CurrencyCard({
    super.key,
    required this.name,
    required this.amount,
    required this.value,
    required this.icon,
    required this.isInverted,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isSelected ? 140 : 100,
          decoration: BoxDecoration(
            color: isInverted
                ? const Color.fromARGB(255, 241, 238, 238)
                : const Color.fromARGB(255, 70, 75, 80),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    Icons.euro_rounded,
                    color: isInverted ? Colors.black : Colors.white,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: isInverted
                          ? const Color.fromARGB(255, 70, 75, 80)
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        color: isInverted
                            ? const Color.fromARGB(255, 70, 75, 80)
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$$value',
                      style: TextStyle(
                        color: isInverted
                            ? const Color.fromARGB(255, 70, 75, 80)
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        // 버튼 눌렀을 때의 동작을 정의합니다.
                      },
                      child: const Text(
                        'Action',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
