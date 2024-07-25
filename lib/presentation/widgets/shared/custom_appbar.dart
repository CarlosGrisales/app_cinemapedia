import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    //final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('Hello, what do you\nwant to watch ?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.white54.withOpacity(0.8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
