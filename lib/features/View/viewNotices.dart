import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotices extends StatefulWidget {
  const ViewNotices({super.key});

  @override
  State<ViewNotices> createState() => _ViewNoticesState();
}

class _ViewNoticesState extends State<ViewNotices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notices')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var notices = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              var notice = notices[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text
                      (notice['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showNoticeDialog(context, notice['title'], notice['content']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showNoticeDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'View Notices',
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
}