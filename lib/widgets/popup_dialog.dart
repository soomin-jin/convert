import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PopupDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        padding: const EdgeInsets.all(20),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text(
              '선택한 자산을 교환할까요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1F6F5), // Lighter grey
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(120, 50), // 버튼의 최소 너비와 높이 설정
                  ),
                  onPressed: onCancel,
                  child: const Text(
                    "아니오",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF00B0AD)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF00B0AD), // Convert button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(120, 50), // 버튼의 최소 너비와 높이 설정
                  ),
                  onPressed: onConfirm,
                  child: const Text(
                    "예",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
