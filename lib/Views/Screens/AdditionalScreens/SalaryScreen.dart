import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ViewModels/Salary_ViewModel.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<SalaryViewModel>(builder: (context, model, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_sharp),
                      ),
                      const Spacer(),
                      const Text(
                        "Salary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 60),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // soft shadow
                        blurRadius: 10, // spread blur
                        offset: const Offset(0, 4), // shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The current net salary based on'),
                              Text('Jan 2025', style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Icon(Icons.calendar_month),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('RS: 15000 / ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                Text('month', style: TextStyle(color: Colors.grey, ),),
                              ],
                            ),
                            Text('Fifteen thousand per month', style: TextStyle(color: Colors.grey.shade600),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // soft shadow
                        blurRadius: 10, // spread blur
                        offset: const Offset(0, 4), // shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: _leaveTypeButton("Earning", model),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _leaveTypeButton("Deduction", model),
                            ),
                          ],
                        ),
                      ),
                      model.selectedLeaveType == 'Earning'
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Column(
                          children: [
                            _salaryRow('Basic', '10,000', false),
                            _salaryRow('Incentive Pay', '3,000', true),
                            _salaryRow('House Rent Allowance', '1,000', false),
                            _salaryRow('Overtime', '1,000', true),
                            const SizedBox(height: 20,),
                            Container(
                              height: 1,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade800 ,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                            ),
                            const SizedBox(height: 10,),
                            _salaryRow('Total', '15,000', false)

                          ],
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Column(
                          children: [
                            _salaryRow('Late In', '1,000', false),
                            _salaryRow('Leave', '1,500', true),
                            _salaryRow('Loan', '1,000', false),
                            const SizedBox(height: 20,),
                            Container(
                              height: 1,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade800 ,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                            ),
                            const SizedBox(height: 10,),
                            _salaryRow('Total', '2,500', false)

                          ],
                        ),
                      )
                    ],
                  ),
                ),


                // Fixed Top Bar

              ],
            );
          })
        ),
      ),
    );
  }

  Widget _leaveTypeButton(String type, SalaryViewModel model) {
    return Expanded(
      child: GestureDetector(
        onTap: () => model.setLeaveType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: model.selectedLeaveType == type ? const Color.fromRGBO(236, 0, 60, 1) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            //border: Border.all(color: Colors.red),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color:
                model.selectedLeaveType == type
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _salaryRow(String first, String second, bool isFilled) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: isFilled ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(first, style: TextStyle(fontSize: 16),),
          Text(second, style: TextStyle(fontSize: 16),),
        ],
      ),
    );
  }

}
