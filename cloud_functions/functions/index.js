// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.sendDistress = functions.database.ref('/{number}/sent/{notificationId}')
    .onCreate((snapshot, context) => {

      const db = admin.database().ref();

      const notification = snapshot.val();
var listOfOperations = [];

      notification.recipients.forEach(num => {
        // console.log(`NOTIFYING ${num}`);
        listOfOperations.push(db.child(num).child('notifications').push().set(notification.notification));
      });

      return Promise.all(listOfOperations);
    });

    exports.onReceiveNotification = functions.database.ref('/{number}/notifications/{notificationId}')
    .onCreate((snapshot, context) => {

      const db = admin.database().ref();

      const notification = snapshot.val();
      notification.id = snapshot.key;

      var listOfOperations = [];

      listOfOperations.push(db.child(`${context.params.number}/newNotifications`).transaction(function(count) {
        var total = 1;  
        if (count) {
            total = total + count;
          }
          return total;
        }));

        listOfOperations.push(
          db.child(`${context.params.number}/fcmToken`).on('value', function(snap) {
            if(snap.exists()){
            return sendPushNotifications(snap.val(), notification);
            }else{
              console.log('TOKEN NOT FOUND');
              return Promise.resolve();
            }
          })
        );

      return Promise.all(listOfOperations);
    });

    function sendPushNotifications (fcmToken, notif){

      console.log('SENDING NOTIFICATION', notif);

    const payload = {
      notification: {
          title: `${notif.subject}`,
          body: `${notif.message}`,

      },
      //todo: pass id here so you can navigate to specific screen in app
      data: {notificationId: notif.id},
 };

 return admin.messaging().sendToDevice(fcmToken, payload);
  };