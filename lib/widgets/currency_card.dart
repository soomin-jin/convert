import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name, amount, value;
  final IconData icon;
  final bool isInverted;

  final _blackColor = const Color.fromARGB(255, 70, 75, 80);

  const CurrencyCard(
      {super.key,
      required this.name,
      required this.amount,
      required this.value,
      required this.icon,
      required this.isInverted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isInverted ? const Color.fromARGB(255, 241, 238, 238) : _blackColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    color: isInverted ? _blackColor : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      color: isInverted ? _blackColor : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 140,
                    height: 30,
                  ),
                  Text(
                    '\$$value',
                    style: TextStyle(
                      color: isInverted ? _blackColor : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }
}
