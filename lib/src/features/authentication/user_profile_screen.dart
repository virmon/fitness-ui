import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_ui/src/features/authentication/settings_screen.dart';
import 'package:fitness_ui/src/features/authentication/user_info_screen.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("Not logged in"));
    }
    // double screenWidth = MediaQuery.of(context).size.width; 

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black, size: 30,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSettingsScreen(),
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView (
        padding: EdgeInsets.all(0.18),
        child: Column(
          children: [
            TopProfileSection(user: currentUser),
            const SizedBox(height: 45),
            UserInfoSection(user: currentUser),
            SizedBox(height: 20),
            UserStatsSection(),
            Divider(color: Colors.grey, thickness: 0.4, height: 40),
            SizedBox(height: 5),
            InfoSection(),
          ],
        ),      
      ),
    );
  }
}

// ignore: camel_case_types
class TopProfileSection extends StatelessWidget {
  final User user;
  const TopProfileSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 290,
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

        Positioned(
          bottom: -40,
          left: 20,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : null,
            child: user.photoURL == null
                ? const Icon(Icons.person, size: 60)
                : null,
          ),
        )
      ],
    );
  }
}

 // ignore: camel_case_types
class UserInfoSection extends StatelessWidget {
  final User user;
  const UserInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.displayName ?? "John Doe",
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFFFF9408)),
              SizedBox(width: 8),
              Text("Intermediate", style: TextStyle(color: Colors.white)),
              SizedBox(width: 16),
              Icon(Icons.calendar_month, color: Color(0xFFFF9408)),
              SizedBox(width: 8),
              Text("XX/XX/XXXX", style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class UserStatsSection extends StatelessWidget {
  const UserStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatCircle(
            label: 'Workouts',
            value: "18",
            color: Color(0xFF696969),
          ),
          StatCircle(
            label: 'Hours',
            value: "16",
            color: Color(0xFF696969),
          ),
        ],
      ),
    );
  }
}

class StatCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatCircle({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 5),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 32,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          buildInfoCardButton(
            context: context,
            label: "My Info",
            icon: Icons.edit_note,
            destination: UserInfoScreen(), // replace with your screen
          ),
          SizedBox(height: 5),
          buildInfoCardButton(
            context: context,
            label: "Workout History",
            icon: Icons.fitness_center,
            destination: UserInfoScreen(), // replace with your screen
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

Widget buildInfoCardButton({
  required BuildContext context,
  required String label,
  required IconData icon,
  required Widget destination,
}) {
  double screenWidth = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    },
    child: Container(
      width: double.infinity,
      height: screenWidth * 0.22,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: screenWidth * 0.08, color: const Color(0xFFFF9408)),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 18),
        ],
      ),
    ),
  );
}
