import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/facilitiesPage.dart';
import 'package:residential_management_system/features/model/Facility.dart';
import 'package:residential_management_system/features/model/Resident.dart';

class ViewFacilityPage extends StatefulWidget {
  final String facilityName;

  const ViewFacilityPage(this.facilityName, {Key? key}) : super(key: key);

  @override
  State<ViewFacilityPage> createState() => _ViewFacilityPageState();
}

class _ViewFacilityPageState extends State<ViewFacilityPage> {
  Facility? facilityData;
  String? selectedTimeSlot;
  String? residentName;
  String? residentPhoneNumber;

  // Define controller for the form fields
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Define list of time slots
  List<String> timeSlots = [
    '8:00 am - 9:00 am',
    '9:00 am - 10:00 am',
    '10:00 am - 11:00 am',
    '11:00 am - 12:00 pm',
    '12:00 pm - 1:00 pm',
    '1:00 pm - 2:00 pm',
    '2:00 pm - 3:00 pm',
    '3:00 pm - 4:00 pm',
    '4:00 pm - 5:00 pm',
    '5:00 pm - 6:00 pm',
    '6:00 pm - 7:00 pm',
    '7:00 pm - 8:00 pm',
    '8:00 pm - 9:00 pm',
    '9:00 pm - 10:00 pm',
  ];

  @override
  void initState() {
    super.initState();
    _fetchFacilityData();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitBookingForm() {
    // Get values from controllers
    final residentName = _nameController.text.trim();
    final residentPhoneNumber = _phoneNumberController.text.trim();

    // Can perform validation here if needed

    // Create a new document in the "Bookings" collection
    FirebaseFirestore.instance.collection('Bookings').add({
      'facilityName': facilityData!.facilityName,
      'residentName': residentName,
      'residentPhoneNumber': residentPhoneNumber,
      'timeSlot': selectedTimeSlot,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    }).then((value) {
      print('Booking submitted successfully');
    }).catchError((error) {
      print('Failed to submit booking: $error');
    });

    // Clear form fields after submission
    //_nameController.clear();
    //_phoneNumberController.clear();
    setState(() {
      selectedTimeSlot = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FacilitiesPage()),
    );
  }

  Future<void> _fetchFacilityData() async {
    try {
      // Debugging: Print the facility name
      print('Querying for facility name: ${widget.facilityName}');

      //trim and debug print the facility name
      final facilityNameTrimmed = widget.facilityName.trim();
      print('Querying for facility name: $facilityNameTrimmed');

      //fetch all documents to debug
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Facility')
          .where('name', isEqualTo: facilityNameTrimmed)
          .get();
      //await FirebaseFirestore.instance.collection('Facility').get();

      // Debugging: Print the number of documents found
      print('Number of documents found: ${querySnapshot.docs.length}');

      for (var doc in querySnapshot.docs) {
        print('Document data: ${doc.data()}');
      }

      // Fetch the facility data from firestore
      querySnapshot = await FirebaseFirestore.instance
          .collection('Facility')
          .where('name', isEqualTo: widget.facilityName)
          .get();

      print('this is for query $querySnapshot');

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        setState(() {
          facilityData =
              Facility.fromMap(snapshot.data() as Map<String, dynamic>);
          print('Facility data fetched: $facilityData'); // Add this line
        });
      } else {
        // Handle the case where the facility does not exist
        setState(() {
          facilityData = null;
          print('no facility found');
        });
      }

      // Fetch the current user's data
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;
        if (userEmail != null) {
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('Resident')
              .doc(userEmail)
              .get();

          if (userSnapshot.exists) {
            Map<String, dynamic> userData =
                userSnapshot.data() as Map<String, dynamic>;
            setState(() {
              residentName = userData['name'];
              residentPhoneNumber = userData['phoneno'];
              _nameController.text = residentName!;
              _phoneNumberController.text = residentPhoneNumber!;
            });
            print('User Data fetched: $residentName');
          } else {
            print('No user data found');
          }
        }
      }
    } catch (e) {
      // Handle any errors that might occur
      setState(() {
        facilityData = null;
        print('Error fetching facility data: $e'); // Add this line
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(facilityData?.facilityName ?? 'No Data'),
      ),
      body: facilityData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Facility Details',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                '${facilityData!.facilityName}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                '${facilityData!.description}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Text(
                                '${facilityData!.location}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Text(
                                '${facilityData!.time}',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 32,
                    ),
                    if (facilityData!.facilityName == 'Gym and Yoga' ||
                        facilityData!.facilityName == 'Swimming Pool')
                      Center(
                        child: Text(
                          'This facility can be used without booking',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (facilityData!.facilityName != 'Gym and Yoga' &&
                        facilityData!.facilityName != 'Swimming Pool')
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Booking Form',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Your Name',
                                  border: OutlineInputBorder(),
                                  enabled: false,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Your Phone Number',
                                  border: OutlineInputBorder(),
                                  enabled: false,
                                ),
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: selectedTimeSlot,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedTimeSlot = newValue;
                                  });
                                },
                                items: timeSlots.map((slot) {
                                  return DropdownMenuItem<String>(
                                    value: slot,
                                    child: Text(slot),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Select Time Slot',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (facilityData!.facilityName != 'Gym and Yoga' &&
                        facilityData!.facilityName != 'Swimming Pool')
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitBookingForm,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            child: Text(
                              'Book Facility',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : Center(
              child: Text('No Facility Data Available'),
            ),
    );
  }
}
