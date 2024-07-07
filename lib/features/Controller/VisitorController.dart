import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residential_management_system/features/model/Visitor.dart';

class VisitorController {
  static final CollectionReference visitorCollection =
      FirebaseFirestore.instance.collection('Visitors');

  static Future<String> saveVisitor(Visitor visitor) async {
    try {
      DocumentReference docRef = await visitorCollection.add(visitor.toMap());
      return docRef.id;
    } catch (e) {
      print('Error saving visitor: $e');
      return '';
    }
  }
}