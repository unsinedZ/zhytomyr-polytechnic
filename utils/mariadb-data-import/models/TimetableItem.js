const {Day} = require("./Day")
const {Activity} = require("./Activity")

class TimetableItem {

    static fromSQL(sqlOutput, activityId) {
        const rawActivity = sqlOutput["activities"].filter((activity) => activity.activity_id == activityId)[0]

        if(!rawActivity)
        {
            return;
        }

        return {
            activity: Activity.fromSQL(sqlOutput, rawActivity),
            ...sqlOutput["days"]
                .filter((day) => day.day_id == rawActivity.activity_day_id)
                .map((day) => day.day_name)
                .map((day) => Day.fromSQL(day))[0],
        }
    }
}

module.exports = {
    TimetableItem
}