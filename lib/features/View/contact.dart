import 'package:flutter/material.dart';
import 'package:residential_management_system/features/View/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}

/*void main() => runApp(MaterialApp(
    home: ContactsListPage(),
    theme: ThemeData(
      primarySwatch: Colors.red,
    )));*/

class ContactsListPage extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: 'Emergency Services', phoneNumber: '999'),
    Contact(name: 'Police', phoneNumber: '03-384 9573'),
    Contact(name: 'Fire Department', phoneNumber: '03-345 4446'),
    Contact(name: 'Hospital', phoneNumber: '03-445 7767'),
    Contact(name: 'Office', phoneNumber: '03-323 3232'),
  ];

  _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text(
          'Contacts',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent[700],
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(contacts[index].name),
                subtitle: Text(contacts[index].phoneNumber),
                trailing: IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Call'),
                          content:
                              Text('Do you want to call ${contacts[index].name}?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Call'),
                              onPressed: () {
                                // TODO:Add call functionality
                                _makePhoneCall(contacts[index].phoneNumber);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
        backgroundColor: Colors.redAccent[700],
      ),
    );
  }
}
