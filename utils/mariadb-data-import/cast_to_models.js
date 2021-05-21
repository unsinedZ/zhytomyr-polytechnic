const opts = require('optimist').argv;
const firebase = require('firebase');
const fs = require('fs');
const crypto = require("crypto");

const {Group} = require("./models/Group");
const {Tutor} = require("./models/Tutor");
const {TimetableItemGroup} = require("./models/TimetableItemGroup");
const {TimetableItemUpdate} = require("./models/TimetableItemUpdate");

(async () => {
  const jsonOutput = JSON.parse(fs.readFileSync(opts.file));
  const timetableKey = crypto.randomBytes(14).toString("hex");
  const rawGroup = jsonOutput["groups"];
  const groups = rawGroup.map((group) => Group.fromSQL(group))

  firebase.initializeApp({
    projectId: "emulator"
  });
  
  const firestore = firebase.firestore();
  firestore.useEmulator("0.0.0.0", 8080);

  await firestore.collection("timetable").doc(timetableKey).set(Object.assign({}, {
    ID: timetableKey,
    expiredAt: (new Date()).setMonth(new Date().getMonth() + 4),
    weekDetermination: 0,
    lastModified: Date.now(),
    enabled: 0
  }))

  groups.forEach(async (group) => {
    await firestore.collection("group").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, group))
  })

  jsonOutput["teachers"].map((tutor) => Tutor.fromSQL(tutor)).forEach(async (tutor) => {
    await firestore.collection("tutor").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, tutor))
  })

  jsonOutput["activities_changes"].map((updateItem) => TimetableItemUpdate.fromSQL(jsonOutput, updateItem)).filter((updateItem) => updateItem != undefined).forEach(async (updateItem) => {
    await firestore.collection("timetable_item_update").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, updateItem))
  })

  const timetable_item_group = rawGroup.map((group, index) => {
    return TimetableItemGroup.fromGroup(jsonOutput, index, timetableKey, "group/" + group.group_name);
  })

  timetable_item_group.forEach(async (timetable) => {
    await firestore.collection("timetable_item_group").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, timetable))
  });

})().catch(console.log)