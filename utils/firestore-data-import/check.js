const admin = require("firebase-admin")
const fs = require('fs');
const params = require("optimist").argv;
const firebase = require('firebase');
const {
    exit
} = require('process');

const {
    TimetableItemGroup
} = require("./models/TimetableItemGroup");
const {
    Activity
} = require("./models/Activity");
const {
    TimetableItem
} = require("./models/TimetableItem");
const {
    Time
} = require("./models/Time");
const {
    Group
} = require("./models/Group");
const {
    Tutor
} = require("./models/Tutor");

const {
    TimetableItemUpdate
} = require("./models/TimetableItemUpdate");


const getAllCollection = async(name, firestore) => [...(await firestore.collection(name).get()).docs.map((document) => document.data())];

(async() => {
    let firestore;

    if (params.emulator) {
        firebase.initializeApp({
            projectId: "emulator"
        });

        (firebase.firestore()).useEmulator("0.0.0.0", 8080);

        firestore = firebase.firestore();

    } else {
        const serviceAccount = JSON.parse(fs.readFileSync(params.credential));

        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });

        firestore = admin.firestore();
    }

    (await getAllCollection("users", firestore)).forEach((user) => {
        compareKeys({
            userId: null,
            groupId: null,
            subgroupId: null
        }, user);
    });

    (await getAllCollection("faculties", firestore)).forEach((faculty) => {
        compareKeys({
            id: null,
            imageUrl: null,
            name: null
        }, faculty);
    });

    (await getAllCollection("groups", firestore)).forEach((group) => {
        compareKeys(new Group(), group);
    });

    (await getAllCollection("tutors", firestore)).forEach((tutor) => {
        compareKeys(new Tutor(), tutor);
    });

    (await getAllCollection("versions", firestore)).forEach((tutor) => {
        compareKeys({
            os: null,
            url: null,
            version: null
        }, tutor);
    });


    (await getAllCollection("timetables", firestore)).forEach((timetableGroupItem) => {
        compareKeys({
            id: null,
            expiredAt: null,
            weekDetermination: 0,
            lastModified: null,
            enabled: null
        }, timetableGroupItem);
    });

    (await getAllCollection("timetable_items_group", firestore)).forEach((timetableGroupItem) => {
        compareKeys(new TimetableItemGroup(), timetableGroupItem);

        timetableGroupItem.items.length == 0 ? console.warn("No any TimetableItems in TimetableItemsGroup: " + timetableGroupItem.key) : timetableGroupItem.items.forEach((timetableItem) => compareTimetableItem(timetableItem));
    });

    (await getAllCollection("timetable_items_update", firestore)).forEach((timetableUpdateItem) => {
        compareKeys(new TimetableItemUpdate(), timetableUpdateItem);
        compareTimetableItem(timetableUpdateItem.item);
    });

    (await getAllCollection("timetable_items_tutor", firestore)).forEach((timetableGroupItem) => {
        compareKeys(new TimetableItemGroup(), timetableGroupItem);

        timetableGroupItem.items.length == 0 ? console.warn("No any TimetableItems in TimetableItemsTutor: " + timetableGroupItem.key) : timetableGroupItem.items.forEach((timetableItem) => compareTimetableItem(timetableItem));
    });


    exit(0);
})().catch((error) => {
    console.error("Error: " + error.message);
    exit(1);
});


function compareKeys(emptyModel, object) {
    if (!object || object == null) {
        console.warn("Object null or undefined")
    }

    Object.keys(object).forEach(key => {
        if ((Object.keys(emptyModel)).lastIndexOf(key) < 0) {
            console.warn("Keys is not valid at object: " + JSON.stringify(object))
        }
    });
}

function compareTimetableItem(timetableItem) {
    compareKeys(new TimetableItem(), timetableItem);
    compareKeys(new Activity(), timetableItem.activity);
    compareKeys(new Time(), timetableItem.activity.time);
    timetableItem.activity.groups.length == 0 ? console.warn("Groups list is empty in TimetableItem: " + timetableItem.id) :
        timetableItem.activity.groups.forEach(group => compareKeys(new Group(), group));
    timetableItem.activity.tutors == 0 ? console.warn("Tutors list is empty in TimetableItem: " + timetableItem.id) :
        timetableItem.activity.tutors.forEach((tutor) => compareKeys(new Tutor, tutor));
}