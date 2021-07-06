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
                    )
                )
            )

            return sqlOutput["activities"].filter((activity) => subgroup.map((subgroup) => subgroup.subgroup_id).includes(activity.activity_subgroup_id))
        }
        return sqlOutput["activities"].filter((activities) => activities.activity_teacher_id == uniqueId)
    }

    static fromGroup(sqlOutput, id, timetableId, key) {
        const timetableItem = this.fromKeyActivities(sqlOutput, key).map((activity) => {
            return Object.assign({}, TimetableItem.fromSQL(sqlOutput, activity.activity_id));
        });

        if (!timetableItem) {
            return;
        }

        return new TimetableItemGroup(
            id,
            timetableId,
            key,
            timetableItem
        )
    }
}

module.exports = {
    TimetableItemGroup
};