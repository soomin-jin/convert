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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isSelected ? 180 : 100,
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
                const Spacer(), // 남은 공간을 차지하여 아래 여백 확보
                const SizedBox(height: 10), // Convert 버튼 상단에 여백 추가
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 100, // 버튼 너비 조정
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1B33B), // Transfer 버튼 배경 색상
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: showPopup,
                        child: const Text(
                          'Convert',
                          style: TextStyle(
                            color: Colors.black, // Transfer 버튼의 텍스트 색상과 동일하게 설정
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
