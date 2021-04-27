const {auth} = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp({});

exports.api = auth.user().onCreate((user) => {
  const users = admin.firestore().collection("users");
  users.add({userId: user.uid, groupId: "", subgroupId: ""});
});
