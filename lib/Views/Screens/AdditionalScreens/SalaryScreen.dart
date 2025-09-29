
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../Services/user_service.dart';
import '../../../ViewModels/UserData_ViewModel.dart';
import '../../../ViewModels/update_salary_viewmodel.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key,});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}
class _SalaryScreenState extends State<SalaryScreen> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final userDataViewModel =
    Provider.of<UserDataViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: userDataViewModel.uid != ''
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const Text('Salary Slip', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  InkWell(
                    onTap: () {
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.transparent,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _totalSalaryCard(),
            const SizedBox(height: 20),
            _salaryCard(),
          ],
        )
            : const SizedBox(
          height: 700,
          width: double.infinity,
          child: Center(
            child: SpinKitCircle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _totalSalaryCard() {
    final updateSalaryViewModel = Provider.of<UpdateSalaryViewModel>(context, listen: true);

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RS. ${updateSalaryViewModel.totalInDigits} / month',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${updateSalaryViewModel.totalInWords} Rupees per month',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _salaryCard() {
    final updateSalaryViewModel = Provider.of<UpdateSalaryViewModel>(context, listen: true);
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Details',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                for (int i = 0; i < updateSalaryViewModel.salaryDetails.length; i++)
                  _salaryItem(
                    updateSalaryViewModel.salaryDetails[i]["nameController"],
                    updateSalaryViewModel.salaryDetails[i]["salaryController"],
                  ),
              ],
            ),
            const SizedBox(height: 10,),
            const Divider(),
            const SizedBox(height: 10,),
            _salaryItem(TextEditingController(text: 'Total'), TextEditingController(text: updateSalaryViewModel.totalInDigits))
          ],
        ),
      ),
    );
  }

  Widget _salaryItem(
      TextEditingController nameController, TextEditingController salaryController) {
    final updateSalaryViewModel = Provider.of<UpdateSalaryViewModel>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Name field (smaller width, compact)
          Text(nameController.text.trim()),
          Text(salaryController.text.trim())
        ],
      ),
    );
  }

}

