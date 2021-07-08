const opts = require('optimist').argv;
const firebase = require('firebase');
const fs = require('fs');
const crypto = require("crypto");

const {
  Group
} = require("./models/Group");
const {
  Tutor
} = require("./models/Tutor");
const {
  TimetableItemGroup
} = require("./models/TimetableItemGroup");
const {
  TimetableItemUpdate
} = require("./models/TimetableItemUpdate");

(async () => {
  let updates = [];
  const jsonOutput = JSON.parse(fs.readFileSync(opts.file));
  const timetableKey = crypto.randomBytes(14).toString("hex");
  const rawGroup = jsonOutput["groups"];
  const groups = rawGroup.map((group) => Group.fromSQL(group))
  const tutors = jsonOutput["teachers"].map((tutor) => Tutor.fromSQL(tutor))

  jsonOutput["activities_changes"].map((updateItem) => TimetableItemUpdate.fromSQL(jsonOutput, updateItem))
    .filter((updateItem) => updateItem).forEach((groupUpdate) => groupUpdate.forEach((update) => updates.push(update)))

  firebase.initializeApp({
    projectId: "emulator"
  });

  const firestore = firebase.firestore();
  firestore.useEmulator("0.0.0.0", 8080);

  await firestore.collection("timetables").doc(timetableKey).set(Object.assign({}, {
    id: timetableKey,
    expiredAt: (new Date()).setMonth(new Date().getMonth() + 4),
    weekDetermination: 0,
    lastModified: Date.now(),
    enabled: 1
  }))

  groups.forEach(async (group) => {
    await firestore.collection("groups").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, group))
  })

  tutors.forEach(async (tutor) => {
    await firestore.collection("tutors").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, tutor))
  })

  updates.forEach(async (updateItem) =>
      await firestore.collection("timetable_items_update").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, updateItem))
  )

  const timetableItemsGroup = groups.map((group, index) =>
    TimetableItemGroup.fromGroup(jsonOutput, index, timetableKey, "group/" + group.id))
    .filter((timetableItemGroup) => timetableItemGroup)

  timetableItemsGroup.forEach(async (timetable) => {
    await firestore.collection("timetable_items_group").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, timetable))
  });

  const timetableItemTutor = tutors.map((tutor, index) =>
  TimetableItemGroup.fromGroup(jsonOutput, index, timetableKey, "tutor/" + tutor.id))
  .filter((timetableItemGroup) => timetableItemGroup)
  
  timetableItemTutor.forEach(async (timetable) => {
    await firestore.collection("timetable_items_tutor").doc(crypto.randomBytes(14).toString("hex")).set(Object.assign({}, timetable))
  });

})().catch((error) => console.error("Error: " + error.message));