import 'package:flutter/material.dart';
import 'package:my_quran_id/data/model/quran_model.dart';

class ListItemSurah extends StatelessWidget {
  final Quran data;
  final VoidCallback onTap;
  const ListItemSurah({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_number.png'),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      data.number.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0XFF240F4F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.latinName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0XFF240F4F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          data.origin!.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0XFF8789A3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0XFFBBC4CE),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${data.numberOfVerse} Ayat'.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0XFF8789A3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Text(
              data.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Color(0XFF863ED5),
                fontFamily: 'Lpmq',
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
