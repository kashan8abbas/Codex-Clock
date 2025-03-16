import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AttendanceCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AttendanceCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide.none,
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide.none,
          right: BorderSide.none,
        ),
        //borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date Section
          Expanded(
            flex: 2,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data['date'].split(' ')[0],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['date'].split(' ')[1],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Time Section
          Expanded(
            flex: 8,
            child: Container(
              height: 65,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('lib/Utils/Icons/checkin.svg'),
                      _timeRow('Check in', data['checkIn']),
                      Text("Check In"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('lib/Utils/Icons/checkout.svg'),
                      _timeRow('Check out', data['checkOut']),
                      Text("Check Out"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('lib/Utils/Icons/totalhours.svg'),
                      _timeRow('Total Hrs', data['hours']),
                      Text("Total Hrs"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Status Section
          Expanded(
            flex: 3,
            child: Container(
              height: 65,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['status'],
                    style: TextStyle(
                      color: data['statusColor'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _statusTag(data['type']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(String label, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _statusTag(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Center(child: Text(text, style: const TextStyle(fontSize: 13))),
    );
  }
}
