class Group {
    static defaultSubgroup = [{
        id: 1,
        name: "1"
    }, {
        id: 2,
        name: "2"
    }]

    facultyId = 0;
    id = 0;
    name = '';
    subgroups = [];
    year = '';

    constructor(facultyId, id, name, subgroups, year) {
        this.facultyId = facultyId;
        this.id = id;
        this.name = name;
        this.subgroups = subgroups;
        this.year = year;
    }

    static getGroupList(sqlOutput, selectedActivity) {
        const groupList = sqlOutput.activities
            .filter((activity) => activity.activity_day_id == selectedActivity.activity_day_id && activity.activity_hour_id == selectedActivity.activity_hour_id && selectedActivity.activity_subject_id == activity.activity_subject_id)
            .map((activity) => Group.fromSubgroup(sqlOutput, activity.activity_subgroup_id))
            .filter((group) => group != null)

        return groupList.filter((group, index, self) =>
            index === self.findIndex((findedGroup) => (
                findedGroup.name === group.name
            ))
        )
    }

    static fromSubgroup(sqlOutput, id) {
        const subgroup = sqlOutput["subgroups"].filter((subgroup) => subgroup.subgroup_id == id)[0]

        const result = sqlOutput["groups"]
            .filter((group) => group.group_name.toUpperCase() == subgroup.subgroup_name.split("[")[0].toUpperCase())[0]

        if (!result) {
            console.info("Group \"" + subgroup.subgroup_name + "\" not found in groups")
            return;
        }

        return Group.fromSQL(result)
    }

    static fromSQL(group) {
        return new Group(group.group_faculty_id, group.group_id, group.group_name, group.group_subgroup_count == 2 ? this.defaultSubgroup : [], group.group_kurs)
    }

    static fromActivity(sqlOutput, selectedActivity) {
        const subgroupList = sqlOutput.activities
            .filter((activity) => activity.activity_day_id == selectedActivity.activity_day_id && activity.activity_hour_id == selectedActivity.activity_hour_id && selectedActivity.activity_subject_id == activity.activity_subject_id)
            .map((activity) => sqlOutput["subgroups"].filter((subgroup) => subgroup.subgroup_id == activity.activity_subgroup_id)[0])

        return this.getGroupList(sqlOutput, selectedActivity).map((group) => {

            if (group.subgroups.length == 0) {
                return group;
            }

            const subgroups = subgroupList
                .filter((selectedSubgroup) => selectedSubgroup.subgroup_name.indexOf(group.name) >= 0)
                .map((subgroup) => subgroup.subgroup_name.split("[")[1].split("]")[0] == 1 ? {
                    id: 1,
                    name: "1"
                } : {
                    id: 2,
                    name: "2"
                })

            return new Group(
                group.facultyId,
                group.id,
                group.name,
                subgroups,
                group.year
            )
        });
    }
}

module.exports = {
    Group
}