import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ui/src/common/alert_message_widget.dart';
import 'package:fitness_ui/src/common/date_provider.dart';
import 'package:fitness_ui/src/common/unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserSettingsScreen extends ConsumerWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("Not logged in"));
    }
    
    final unit = ref.watch(weightUnitProvider);
    final index = unit == WeightUnit.lbs ? 0 : 1;
    final dateFormat = ref.watch(dateFormatProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white
          )
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView (
        padding: EdgeInsets.all(0.18),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16,60,16,16),
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [Color(0xFFCA3F16), Color(0xFFFF9408)],
                      stops: <double>[0.2, 1.0],
                      radius: 0.7
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsetsGeometry.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Unit of \nMeasurement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                      Spacer(),
                      ToggleSwitch(
                        minWidth: 70.0,
                        initialLabelIndex: index,
                        cornerRadius: 20.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        labels: ['lbs', 'kgs'],
                        activeBgColor: [Color(0xFFCA3F16)],
                        onToggle: (selectedIndex) {
                          final selectedUnit = selectedIndex == 0 ? WeightUnit.lbs : WeightUnit.kgs;
                          ref.read(weightUnitProvider.notifier).state = selectedUnit;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(color: Color(0xFF2D2D2D)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Date Format',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                      Spacer(),
                      DropdownButton<DateFormatOption>(
                        value: dateFormat,
                        dropdownColor: Color(0xFF2D2D2D),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        underline: SizedBox(),
                        borderRadius: BorderRadius.circular(20),
                        onChanged: (newFormat) {
                          if (newFormat != null) {
                            ref.read(dateFormatProvider.notifier).state = newFormat;
                          }
                        },
                        items: DateFormatOption.values.map((option) {
                          String label;
                          switch (option) {
                            case DateFormatOption.mmddyyyy:
                              label = 'MM/DD/YYYY';
                              break;
                            case DateFormatOption.ddmmyyyy:
                              label = 'DD/MM/YYYY';
                              break;
                          }
                          return DropdownMenuItem<DateFormatOption>(
                            value: option,
                            child: Text(label),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Color(0xFF2D2D2D)),
                  SizedBox(height: 10),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:(){
                          AlertMessageWidget.showConfirmationDialog(
                            context: context,
                            alertTitle: 'Log out',
                            alertQuestion: 'Are you sure you want to log out?',
                            onOk: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            onCancel: () {
                            },
                          );
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF9408),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),
                        )
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),      
      ),
    );
  }
}
