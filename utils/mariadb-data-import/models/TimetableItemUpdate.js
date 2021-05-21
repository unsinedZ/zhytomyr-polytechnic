const {Time} = require("./Time");
const {Day} = require("./Day");
const {TimetableItem} = require("./TimetableItem")

class TimetableItemUpdate {
    static fromSQL(sqlOutput, updateItem) {
        const timetableItem = TimetableItem.fromSQL(sqlOutput, updateItem.activity_change_id);

        if(!timetableItem)
        {
            return;
        }

        return {
            id: updateItem.change_id,
            date: Day.fromSQL(updateItem.new_day),
            time: Time.fromSQL(updateItem.new_hour),
            item: timetableItem
        }
    }
}

module.exports = {
    TimetableItemUpdate
}