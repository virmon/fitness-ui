import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.pushNamed(AppRoute.profile.name);
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
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
                    "Hello!",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                  buildGradientStatCard(screenWidth, 'Workout Streak', '8 days'),
                  SizedBox(width: screenWidth * 0.035),
                  buildStatCard(screenWidth, 'Workouts this\nweek', '8'),
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
                  buildLastWorkoutCard(screenWidth, 'Workout Name', 'XX/XX/XXXX', 'XX minutes'),
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
                  buildStatCard(screenWidth, 'Average Workout\nDuration', '60 mins'),
                  SizedBox(width: screenWidth * 0.035),
                  buildStatCard(screenWidth, 'Workouts this\nweek', '16'),
                ],
              ),
              SizedBox(height: screenWidth * 0.035),
              Row(
                children: [
                  buildLongStatCard(screenWidth, 'Top Exercise this week', 'Push-ups'),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildGradientStatCard(double screenWidth, String title, String value){
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

  Widget buildStatCard(double screenWidth, String statType, String statValue){
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

  Widget buildLongStatCard(double screenWidth, String statTitle, String statValue){
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

  Widget buildLastWorkoutCard(double screenWidth, String workoutTitle, String workoutDate, String workoutDuration){
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
            SizedBox(height: screenWidth * 0.025),
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