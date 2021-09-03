const {
    TimetableItem
} = require("./TimetableItem")

class TimetableItemGroup {
    id = null;
    timetableId = null;
    key = null;
    items = [];

    constructor(id, timetableId, key, items) {
        this.id = id;
        this.timetableId = timetableId;
        this.key = key;
        this.items = items;
    }

    static fromKeyActivities(sqlOutput, key) {
        const uniqueId = key.split("/")[1]

        if (key.indexOf("group") >= 0) {
            const groupItem = sqlOutput["groups"].filter(group => group.group_id == uniqueId)[0];

            const subgroup = sqlOutput["subgroups"]
                .filter((subgroup) => subgroup.subgroup_name.indexOf(groupItem.group_name + "[") >= 0)
                .filter((subgroup, index, self) =>
                    index === self.findIndex((findedSubgroup) => (
                        findedSubgroup.group_name === subgroup.group_name
                    ))
                )

            return sqlOutput["activities"].filter((activity) => subgroup.map((subgroup) => subgroup.subgroup_id).includes(activity.activity_subgroup_id))
        }
        return sqlOutput["activities"].filter((activities) => activities.activity_teacher_id == uniqueId).filter((activity, index, self) =>
            index === self.findIndex((findedActivity) => (
                findedActivity.activity_day_id === activity.activity_day_id &&
                findedActivity.activity_hour_id === activity.activity_hour_id &&
                findedActivity.activity_tag_id === activity.activity_tag_id &&
                findedActivity.activity_room_id === activity.activity_room_id &&
                findedActivity.activity_subject_id === activity.activity_subject_id
            ))
        )
    }

    static fromGroup(sqlOutput, id, timetableKey, key) {
        const timetableItems = this.fromKeyActivities(sqlOutput, key).map((activity) => {
            return Object.assign({}, TimetableItem.fromSQL(sqlOutput, activity.activity_id));
        });

        if (!timetableItems) {
            return;
        }
        timetableItems
        return new TimetableItemGroup(
            id,
            timetableKey,
            key,
            timetableItems
        )
    }
}

module.exports = {
    TimetableItemGroup
};