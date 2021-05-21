class Day {

    static dayNames = [{
        id: 1,
        name: "Понеділок"
    }, {
        id: 2,
        name: "Вівторок"
    }, {
        id: 3,
        name: "Середа"
    }, {
        id: 4,
        name: "Четвер"
    }, {
        id: 5,
        name: "П'ятниця"
    }, {
        id: 6,
        name: "Субота"
    }, {
        id: 7,
        name: "Неділя"
    }]

    static fromSQL(dateString) {
        const day = dateString.split(" ")
        return {
            dayNumber: this.dayNames
                .filter((dayName) => dayName.name = day[0])
                .map((dayName) => dayName.id)[0],
            weekNumber: parseInt(day[1])
        }
    }
}

module.exports = {
    Day
}