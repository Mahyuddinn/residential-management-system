/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const db = admin.firestore();

// Function to add maintenance fees monthly
exports.addMonthlyMiantenanceFee = onSchedule("0 0 * * *", async (context) => {
  try {
    const now = admin.firestore.Timestamp.now();
    const batch = db.batch();
    const residentRef = db.collection("Resident");

    const snapshot = await residentRef.get();
    snapshot.forEach((doc) => {
      const docRef = residentRef.doc(doc.id);
      const currentTotalFees = doc.data().totalMaintenanceFees || 0;
      const newMaintenanceFees = 10;
      batch.update(docRef, {
        maintenanceFees: admin.firestore.FieldValue.arrayUnion({
          amount: newMaintenanceFees,
          date: now,
        }),
        totalMaintenanceFees: currentTotalFees + newMaintenanceFees,
      });
    });

    await batch.commit();
    console.log("Maintenance fee added to all resident at:", now.toDate());
  } catch (error) {
    logger.error("Error adding the maintenance fees:", error);
  }
});

exports.callback = onRequest((request, response) => {
  // Check if the request method is POST
  if (request.method !== "POST") {
    logger.error("Method Not Allowed");
    return response.status(405).send("Method Not Allowed");
  }

  // Log the received data
  const data = request.body;
  logger.info("Callback received:", data);

  // Save the data to Firestore
  const db = admin.firestore();
  db.collection("callbacks").add(data)
      .then((docRef) => {
        logger.info("Document written with ID:", docRef.id);
        response.status(200).send("Callback received and logged");
      })
      .catch((error) => {
        logger.error("Error adding document:", error);
        response.status(500).send("Error logging callback");
      });
});
