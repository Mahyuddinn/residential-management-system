import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_system/features/model/Visitor.dart';

class VisitorController {
  static final CollectionReference visitorCollection =
      FirebaseFirestore.instance.collection('Visitors');

  static Future<void> saveVisitor(Visitor visitor) async {
    try {
      await visitorCollection.add(visitor.toMap());
    } catch (e) {
      print('Error saving visitor: $e');
    }
  }
}