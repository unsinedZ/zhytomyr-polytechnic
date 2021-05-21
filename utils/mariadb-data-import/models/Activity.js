const {Tutor} = require("./Tutor");
const {Time} = require("./Time");
const {Subject} = require("./Subject");
const {Room} = require("./Room");
const {Type} = require("./Type");
const {Group} = require("./Group");


class Activity {

    static fromSQL(sqlOutput, activityItem) {
        return {
            id: activityItem.activity_id,
            time: Time.fromTimeId(sqlOutput, activityItem.activity_hour_id),
            tutor: Tutor.fromTutorId(sqlOutput, activityItem.activity_teacher_id),
            name: Subject.fromSQL(sqlOutput, activityItem.activity_subject_id),
            room: Room.fromSQL(sqlOutput, activityItem.activity_room_id),
            type: Type.fromSql(sqlOutput, activityItem.activity_tag_id),
            groups: Group.getGroupList(sqlOutput, activityItem)
        }
    }

    static fromKeyActivities(sqlOutput, key) {
        const uniqueId = key.split("/")[1]
        
        if(key.indexOf("group") >= 0) {
            const subgroup = sqlOutput["subgroups"].filter((subgroup) => subgroup.subgroup_name.indexOf(uniqueId + "[") >= 0)

            return sqlOutput["activities"].filter((activity) => subgroup.map((subgroup) => subgroup.subgroup_id).includes(activity.activity_subgroup_id))
        }

         return sqlOutput["activities"].filter((activities) => activities.activity_teacher_id == uniqueId)
    
    }
}

module.exports = {Activity}