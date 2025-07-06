import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ui/src/features/authentication/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_ui/src/common/alert_message_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Not logged in"));
    }
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Color(0xFFFF9408), size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      endDrawer: AppDrawer(user: user),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Text(
                    "Hello ${user?.displayName?.split(' ').first ?? 'John'}!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    )
                  )
                ],
              ),
              SizedBox(height: screenWidth * 0.05),

              // Progress Section
              Text(
                "Your Progress",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: screenWidth * 0.025),
              Row(
                children: [
                  BuildGradientStatCard(screenWidth, 'Workout Streak', '8 days'),
                  SizedBox(width: screenWidth * 0.035),
                  BuildStatCard(screenWidth, 'Workouts this\nweek', '8'),
                ],
              ),
              SizedBox(height: screenWidth * 0.05),

              // Last Workout Section
              Text(
                "Last Workout",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: screenWidth * 0.025),
              Row(
                children: [
                  BuildLastWorkoutCard(screenWidth, 'Workout Name', 'XX/XX/XXXX', 'XX minutes'),
                ],
              ),
              SizedBox(height: screenWidth * 0.05),

              // Stats Section
              Text(
                "Fitness Stats",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: screenWidth * 0.025),
              Row(
                children: [
                  BuildStatCard(screenWidth, 'Average Workout\nDuration', '60 mins'),
                  SizedBox(width: screenWidth * 0.035),
                  BuildStatCard(screenWidth, 'Workouts this\nweek', '16'),
                ],
              ),
              SizedBox(height: screenWidth * 0.035),
              Row(
                children: [
                  BuildLongStatCard(screenWidth, 'Top Exercise this week', 'Push-ups'),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  Widget BuildGradientStatCard(double screenWidth, String title, String value){
    return Expanded(
      child: Container(
        height: screenWidth * 0.36,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [Color(0xFFFF9408), Color(0xFFCA3F16)],
            stops: <double>[0.6, 1.0],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.black,
              )
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.085,
                color: Colors.black,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildStatCard(double screenWidth, String statType, String statValue){
    return Expanded(
      child: Container(
        height: screenWidth * 0.36,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statType,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.white,
              )
            ),
            const Spacer(),
            Text(
              statValue,
              style: TextStyle(
                fontSize: screenWidth * 0.085,
                color: Color(0xFFFF9408),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildLongStatCard(double screenWidth, String statTitle, String statValue){
    return Expanded(
      child: Container(
        height: screenWidth * 0.36,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statTitle,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.white,
              )
            ),
            const Spacer(),
            Text(
              statValue,
              style: TextStyle(
                fontSize: screenWidth * 0.085,
                color: Color(0xFFFF9408),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildLastWorkoutCard(double screenWidth, String workoutTitle, String workoutDate, String workoutDuration){
    return Expanded(
      child: Container(
        height: screenWidth * 0.36,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              workoutTitle,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.white,
              )
            ),
            SizedBox(height: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.orange),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: const Color(0xFFFF9408)
                        ),
                      ),
                      Text(
                        workoutDate,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        "Duration",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: const Color(0xFFFF9408)
                        ),
                      ),
                      Text(
                        workoutDuration,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ]
              ), 
            )
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final User user;
  const AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  user.displayName ?? "John Doe",
                  style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Height: 120 lbs",
                      style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsetsGeometry.all(10)),
                    Text(
                      "Weight: 5'3\"",
                      style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFFFF9408)),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center, color: Color(0xFFFF9408)),
            title: const Text('My Workouts', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const WorkoutsScreen()),
              // );
            },
          ),
          const Spacer(),
          Divider(color: Colors.grey, thickness: 0.4, height: 40),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFFFF9408)),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFFFF9408)),
            title: const Text('Account', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF9408)),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: (){
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
          ),
        ],
      ),
    );
  }
}