import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String name;
  final String code;
  final String amount;
  final IconData icon;
  final bool isInverted;
  final int order;

  final _blackColor = const Color(0xFF1F2123);

  const CurrencyCard({
    Key? key,
    required this.name,
    required this.code,
    required this.amount,
    required this.icon,
    required this.isInverted,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -12 * (order - 1)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isInverted ? Colors.white : _blackColor,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isInverted ? _blackColor : Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        color: isInverted ? _blackColor : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        color: isInverted
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              scale: 3.5,
              child: Transform.translate(
                offset: const Offset(-8, 12),
                child: Icon(
                  icon,
                  color: isInverted ? _blackColor : Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
