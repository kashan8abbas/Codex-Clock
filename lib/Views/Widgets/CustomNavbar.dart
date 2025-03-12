import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            color: const Color.fromARGB(255, 255, 255, 255),
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
                    icon:
                        selectedIndex != 0
                            ? Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer red home border
                                SvgPicture.asset(
                                  "lib/Utils/Icons/home.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Colors.red,
                                    BlendMode.srcIn,
                                  ), // Red Border
                                  width: 27,
                                  height: 27,
                                ),
                                // Inner white home icon
                                SvgPicture.asset(
                                  "lib/Utils/Icons/home.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ), // White Fill
                                  width: 20,
                                  height: 20,
                                ),
                                // Red Door inside home
                                Positioned(
                                  bottom: 3, // Adjust based on icon structure
                                  child: Container(
                                    width: 6,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(
                                        2,
                                      ), // Optional rounded door effect
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : SvgPicture.asset(
                              "lib/Utils/Icons/home.svg",
                              colorFilter: const ColorFilter.mode(
                                Colors.red, // Fully red when selected
                                BlendMode.srcIn,
                              ),
                            ),
                  ),

                  // Empty space for floating button
                  const SizedBox(width: 60),

                  // Menu Button
                  IconButton(
                    onPressed: () => onItemTapped(2),
                    icon: Icon(
                      size: 30,
                      Icons.menu_open_outlined,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: SvgPicture.asset(
                "lib/Utils/Icons/scan.svg",
                colorFilter: const ColorFilter.mode(
                  Color.fromARGB(255, 255, 255, 255), // Fully red when selected
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
