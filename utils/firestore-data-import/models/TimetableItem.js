const {
    Day
} = require("./Day")
const {
    Activity
} = require("./Activity")

class TimetableItem {

    activity = null;
    dayNumber = null;
    weekNumber = null;

    constructor(activity, dayNumber, weekNumber) {
        this.activity = activity;
        this.dayNumber = dayNumber;
        this.weekNumber = weekNumber;
    }

    static fromSQL(sqlOutput, activityId) {

        const rawActivity = sqlOutput["activities"].filter((activity) => activity.activity_id == activityId)[0]

        if (!rawActivity) {
            return;
        }

        const day = sqlOutput["days"]
            .filter((day) => day.day_id == rawActivity.activity_day_id)
            .map((day) => day.day_name)
            .map((day) => Object.assign({}, Day.fromSQL(day)))[0];

        return new TimetableItem(
            Object.assign({}, Activity.fromSQL(sqlOutput, rawActivity)),
            day.dayNumber,
            day.weekNumber
        )
    }

    static fromUpdateItem(sqlOutput, updateItem) {
        const day =  Day.fromSQL(updateItem.new_day);

        return new TimetableItem(Object.assign({}, Activity.fromUpdate(sqlOutput, updateItem)), day.dayNumber, day.weekNumber)
    }


}

module.exports = {
    TimetableItem
}