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

    dayNumber = null;
    weekNumber = null;

    constructor(dayNumber, weekNumber) {
        this.dayNumber = dayNumber;
        this.weekNumber = weekNumber;
    }

    static fromSQL(dateString) {
        const day = dateString.split(" ")
        return new Day(
            this.dayNames
                .filter((dayName) => dayName.name = day[0])
                .map((dayName) => dayName.id)[0],
            parseInt(day[1])
        )
    }
}

module.exports = {
    Day
}