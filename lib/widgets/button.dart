import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final double width; // 너비를 설정할 매개변수 추가
  final VoidCallback onTap; // onTap 매개변수 추가

  const Button({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.width, // 생성자에서 너비를 초기화
    required this.onTap, // 생성자에서 onTap 초기화
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // GestureDetector의 onTap에 콜백 함수 연결
      child: Container(
        width: width, // Container의 너비 설정
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
