const {Tutor} = require("./Tutor");
const {Time} = require("./Time");
const {Subject} = require("./Subject");
const {Room} = require("./Room");
const {Type} = require("./Type");
const {Group} = require("./Group");


class Activity {
    name = '';
    time = null;
    tutor = [];
    room = '';
    type = '';
    groups = [];

    constructor(name, time, tutor, room, type, groups) {
        this.name = name
        this.time = time;
        this.tutor = tutor;
        this.room = room;
        this.type = type;
        this.groups = groups;
    }
    
    static fromSQL(sqlOutput, activityItem) {
        return new Activity(
            Subject.fromSQL(sqlOutput, activityItem.activity_subject_id).name,
            Object.assign({}, Time.fromTimeId(sqlOutput, activityItem.activity_hour_id)),
            Tutor.fromTutorId(sqlOutput, activityItem.activity_teacher_id).map(tutor => Object.assign({}, tutor)),
            Room.fromSQL(sqlOutput, activityItem.activity_room_id).name,
            Type.fromSql(sqlOutput, activityItem.activity_tag_id).name,
            Group.getGroupList(sqlOutput, activityItem).map(group => Object.assign({}, group))
        )
    }

    static fromUpdate(sqlOutput, updateItem) {

        const activityItem = sqlOutput['activities'].filter((activity) => updateItem.activity_change_id == activity.activity_id)[0]
        
        if(!activityItem) {
            return;
        }

        return new Activity(
            Subject.fromSQL(sqlOutput, activityItem.activity_subject_id).name,
            Object.assign({}, Time.fromSQL(updateItem.new_hour)),
            Tutor.fromTutorId(sqlOutput, activityItem.activity_teacher_id).map(tutor => Object.assign({}, tutor)),
            updateItem.new_room,
            Type.fromSql(sqlOutput, activityItem.activity_tag_id).name,
            Group.getGroupList(sqlOutput, activityItem).map(group => Object.assign({}, group))
        )
    }

}

module.exports = {Activity}