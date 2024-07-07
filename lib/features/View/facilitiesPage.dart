import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/facilityStatus.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:residential_management_system/features/View/profile_page.dart';
import 'package:residential_management_system/features/View/viewFacility.dart';

class FacilitiesPage extends StatefulWidget {
  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FacilitiesList(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Facilities',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.redAccent[700],
      elevation: 0.0,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      backgroundColor: Colors.redAccent[700],
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
        }
      },
    );
  }
}

class FacilitiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 22.0),
      children: [
        FacilityButton(
          label: 'View Booking Status',
          icon: Icons.book_online,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewBookingStatusPage()),
            );
          },
        ),
        SizedBox(
          height: 8,
        ),
        FacilityButton(
          label: 'Kasawari Hall',
          icon: Icons.home_filled,
          onPressed: () {
            navigateToViewFacilityPage(context, 'Kasawari Hall');
          },
        ),
        SizedBox(
          height: 8,
        ),
        FacilityButton(
          label: 'Gym and Fitness',
          icon: Icons.fitness_center,
          onPressed: () {
            navigateToViewFacilityPage(context, 'Gym and Yoga');
          },
        ),
        SizedBox(
          height: 8,
        ),
        FacilityButton(
          label: 'Badminton Hall',
          icon: Icons.sports_tennis,
          onPressed: () {
            navigateToViewFacilityPage(context, 'Badminton');
          },
        ),
        SizedBox(
          height: 8,
        ),
        FacilityButton(
          label: 'Swimming Pool',
          icon: Icons.pool,
          onPressed: () {
            navigateToViewFacilityPage(context, 'Swimming Pool');
          },
        ),
        SizedBox(
          height: 8,
        ),
        FacilityButton(
          label: 'Game Room',
          icon: Icons.gamepad,
          onPressed: () {
            navigateToViewFacilityPage(context, 'Game Room');
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

void navigateToViewFacilityPage(BuildContext context, String facilityName) {
  if (facilityName.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFacilityPage(facilityName),
      ),
    );
  } else {
    // handle the case where the facilityName is empty
    print('Facility name is empty');
  }
}

class FacilityButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const FacilityButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          minimumSize: Size(double.infinity, 80),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
