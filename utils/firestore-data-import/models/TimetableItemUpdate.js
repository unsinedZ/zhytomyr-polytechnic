const {Time} = require("./Time");
const {Day} = require("./Day");
const {TimetableItem} = require("./TimetableItem")

class TimetableItemUpdate {
    static fromSQL(sqlOutput, updateItem) {
        const timetableItem = TimetableItem.fromUpdateItem(sqlOutput, updateItem);
        
        if(!timetableItem)
        {
            return;
        }
        
        return {
            id: updateItem.change_id,
            date: updateItem.date,
            key: "update/"+ updateItem.activity_change_id,
            item: Object.assign({}, timetableItem)
        }
    }
}

module.exports = {
    TimetableItemUpdate
}