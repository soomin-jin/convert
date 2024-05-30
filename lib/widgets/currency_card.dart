import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, amount, value;
  final IconData icon;
  final bool isInverted;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback showPopup;

  const CurrencyCard({
    super.key,
    required this.name,
    required this.amount,
    required this.value,
    required this.icon,
    required this.isInverted,
    required this.isSelected,
    required this.onTap,
    required this.showPopup,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
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
                  height: 20, // 상단 여백 추가
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
