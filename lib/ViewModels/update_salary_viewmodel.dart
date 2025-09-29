import 'package:flutter/cupertino.dart';

class UpdateSalaryViewModel with ChangeNotifier{

  List<Map<String, dynamic>> _salaryDetails = [];
  String _totalInDigits = '';
  String _totalInWord = '';

  List<Map<String, dynamic>> get salaryDetails => _salaryDetails;
  String get totalInDigits => _totalInDigits;
  String get totalInWords => _totalInWord;

  void setList(List<Map<String, dynamic>> data) {
    _salaryDetails = data;
    notifyListeners();
  }

  void addEntry(Map<String, dynamic> entry) {
    _salaryDetails.add(entry);
    notifyListeners();
  }

  void deleteEntry(int index) {
    _salaryDetails.removeAt(index);
    notifyListeners();
  }

  String _convertNumberToWords(int number) {
    if (number == 0) return "Zero";

    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine"
    ];
    final teens = [
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen"
    ];
    final tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety"
    ];

    String words = "";

    if (number >= 1000) {
      int thousands = number ~/ 1000;
      if (thousands >= 20) {
        words += "${tens[thousands ~/ 10]} ";
        if (thousands % 10 != 0) {
          words += "${units[thousands % 10]} ";
        }
      } else if (thousands >= 10) {
        words += "${teens[thousands - 10]} ";
      } else {
        words += "${units[thousands]} ";
      }
      words += "Thousand ";
      number %= 1000;
    }

    if (number >= 100) {
      words += "${units[number ~/ 100]} Hundred ";
      number %= 100;
    }

    if (number >= 20) {
      words += "${tens[number ~/ 10]} ";
      number %= 10;
    } else if (number >= 10) {
      words += "${teens[number - 10]} ";
      number = 0;
    }

    if (number > 0) {
      words += units[number];
    }

    return words.trim();
  }


  void getTotalInWord() {
    int totalSalary = 0;
    for (var item in salaryDetails) {
      final value = int.tryParse(item["salaryController"].text) ?? 0;
      totalSalary += value;
    }

    _totalInDigits = totalSalary.toString();
    _totalInWord = _convertNumberToWords(totalSalary);
    notifyListeners();
  }
}