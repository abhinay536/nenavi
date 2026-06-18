import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Links patients to caregivers in Firestore and processes pending links.
class PatientLinkService {
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  /// Creates the patient entry under the caregiver's `patients` subcollection.
  static Future<void> linkPatientToCaregiver({
    required String patientUid,
    required String patientEmail,
    required String caregiverUid,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(caregiverUid)
        .collection('patients')
        .doc(patientUid)
        .set({
          'patientUid': patientUid,
          'patientEmail': patientEmail,
          'linkedAt': FieldValue.serverTimestamp(),
        });
  }

  /// Moves any legacy `pending_patient_links` into the caregiver's patient list.
  static Future<void> processPendingLinksForCaregiver(
    String caregiverUid,
  ) async {
    try {
      final pending = await FirebaseFirestore.instance
          .collection('pending_patient_links')
          .where('caregiverUid', isEqualTo: caregiverUid)
          .where('status', isEqualTo: 'pending')
          .get()
          .timeout(const Duration(seconds: 20));

      if (pending.docs.isEmpty) return;

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in pending.docs) {
        final data = doc.data();
        final patientUid = data['patientUid'] as String?;
        final patientEmail = data['patientEmail'] as String?;
        if (patientUid == null || patientUid.isEmpty) continue;

        final patientRef = FirebaseFirestore.instance
            .collection('users')
            .doc(caregiverUid)
            .collection('patients')
            .doc(patientUid);

        batch.set(patientRef, {
          'patientUid': patientUid,
          'patientEmail': patientEmail ?? 'Unknown',
          'linkedAt': data['linkedAt'] ?? FieldValue.serverTimestamp(),
        });
        batch.update(doc.reference, {'status': 'linked'});
      }

      await batch.commit().timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('Error processing pending patient links: $e');
    }
  }
}
