import 'package:residential_management_system/features/model/Resident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ResidentController {
  static final CollectionReference residentsCollection =
      FirebaseFirestore.instance.collection('Resident');

  static String saveResidentToFirestore(Resident resident) {
    try {
      FirebaseFirestore.instance
          .collection('Resident')
          .doc(resident.getemail) // Use the email as the document ID
          .set({
        'name': resident.getname,
        'email': resident.getemail,
        'phoneno': resident.getphoneno,
        'housenumber': resident.gethouseno,
        'residentname': resident.getresidentname,
        'block': resident.getblock,
        'floor': resident.getfloor,
      });
      print('Resident ${resident.getname} saved to Firestore!');
      return 'Resident Registered/Updated Successfully!';
    } catch (e) {
      print('Error saving resident data: $e');
      return 'Error saving resident data: $e';
    }
    // Add any additional fields here
  }

  static Future<List<Resident>> getResidentsWithSameDetails(
      Resident currResident) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<Resident> matchingResidents = [];
    print(currResident.getresidentname);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Resident')
          .where('residentname', isEqualTo: currResident.getresidentname)
          .where('block', isEqualTo: currResident.getblock)
          .where('floor', isEqualTo: currResident.getfloor)
          .where('housenumber', isEqualTo: currResident.gethouseno)
          .get();

      if (snapshot.docs.isNotEmpty) {
        matchingResidents =
            snapshot.docs.map((doc) => Resident.fromMap(doc.data())).toList();
      }
    } catch (e) {
      print(e);
    }

    return matchingResidents;
  }

  static Future<void> updateResident(Resident resident) async {
    await residentsCollection.doc(resident.email).update({
      'name': resident.name,
      'phoneno': resident.phoneno,
      'residentname': resident.residentname,
      'block': resident.block,
      'floor': resident.floor,
      'housenumber': resident.houseno,
    });
  }

  static Future<void> deleteResident(Resident resident) async {
    await residentsCollection.doc(resident.email).delete();
  }

  static Future<void> addResident(Resident resident) async {
    await residentsCollection.doc(resident.email).set({
      'name': resident.name,
      'email': resident.email,
      'phoneno': resident.phoneno,
      'residentname': resident.residentname,
      'block': resident.block,
      'floor': resident.floor,
      'housenumber': resident.houseno,
    });
  }
}
