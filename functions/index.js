/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

exports.generateCardDetails = functions.https.onRequest((request, response) => {
    const cardNetwork = request.body.cardNetwork;
    const cardNumber = generateCardNumber(cardNetwork.toString());
    const cvv = _generateRandomDigits(3);
    const authUserId = request.body.authUserId;
    try {
        const docRef = db.collection("users").doc(authUserId);
        docRef.update({
            card: {
                cardNumber: cardNumber,
                cvv: cvv,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
            },
        });
        response.status(200).send("Card details generated successfully");

    } catch (error) {
        response.send(error);
    }       
}
);


const generateCardNumber = (cardNetwork) => {
    let cardNumber = '';
  
    switch (cardNetwork) {
      case 'Visa':
        cardNumber += '4'; // Первая цифра для Visa
        cardNumber += '60002'; // Префикс для вашего банка
        cardNumber += _generateRandomDigits(10); // Оставшиеся 10 цифр
        break;
      case 'Mastercard':
        cardNumber += '5'; // Первая цифра для Mastercard
        cardNumber += '60002'; // Префикс для вашего банка
        cardNumber += _generateRandomDigits(10); // Оставшиеся 10 цифр
        break;
      default:
        throw Exception('Unsupported card network');
    }
  
    return cardNumber;
  }

  const _generateRandomDigits = (length) => {
    let randomDigits = '';
    for (let i = 0; i < length; i++) {
      randomDigits += Math.floor(Math.random() * 10).toString();
    }
    return randomDigits;
  };

  

  


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
