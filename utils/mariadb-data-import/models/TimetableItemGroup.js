const {Activity} = require("./Activity")

class TimetableItemGroup {

    static fromGroup(sqlOutput, id, timetableId, key) {
        return {
            id,
            timetableId,
            key,
            items: Activity.fromKeyActivities(sqlOutput, key).map((activity) => Activity.fromSQL(sqlOutput, activity))
        }
    }

}

module.exports = {TimetableItemGroup};