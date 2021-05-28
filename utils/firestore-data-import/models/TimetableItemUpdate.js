const {
    TimetableItem
} = require("./TimetableItem")
const {
    Group
} = require("./Group")

class TimetableItemUpdate {
    id = null
    date = null
    key = null
    item = null

    constructor(id, date, key, item) {
        this.id = id;
        this.date = date;
        this.key = key;
        this.item = item;
    }

    static fromSQL(sqlOutput, updateItem) {
        const timetableItem = TimetableItem.fromUpdateItem(sqlOutput, updateItem);
        const activity = sqlOutput["activities"].filter((activity) => activity.activity_id == updateItem.activity_change_id)[0]

        if (!timetableItem || !activity) {
            return;
        }

        return Group.fromActivity(sqlOutput, activity).map((group) => new TimetableItemUpdate(
                updateItem.change_id,
                updateItem.date,
                "update/" + group.id,
                Object.assign({}, timetableItem)));
                
        }
    }

    module.exports = {
        TimetableItemUpdate
    }