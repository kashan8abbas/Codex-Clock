import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom Navigation Bar with a deeper notch
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: BottomAppBar(
            color: const Color.fromARGB(255, 168, 77, 77),
            shape: const CircularNotchedRectangle(),
            notchMargin: 10, // Prevent clipping
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Button
                  IconButton(
                    onPressed: () => onItemTapped(0),
                    icon: Icon(
                      Icons.home,
                      color: selectedIndex == 0 ? Colors.red : Colors.grey,
                    ),
                  ),

                  // Empty space for floating button
                  const SizedBox(width: 60),

                  // Menu Button
                  IconButton(
                    onPressed: () => onItemTapped(2),
                    icon: Icon(
                      Icons.menu,
                      color: selectedIndex == 2 ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating Scan Button - Centered
        Positioned(
          bottom: 15, // Slightly raised to avoid overlapping
          child: FloatingActionButton(
            onPressed: () => onItemTapped(1),
            backgroundColor: Colors.red,
            elevation: 6, // Added shadow for visibility
            shape: const CircleBorder(),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}
