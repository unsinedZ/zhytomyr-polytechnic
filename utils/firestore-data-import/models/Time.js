class Time {
    start = ''
    end = ''

    constructor(start, end) {
        this.start = start;
        this.end = end;
    }

    static fromTimeId(sqlOutput, timeId) {
        return sqlOutput["hours"].filter((time) => time.hour_id == timeId)
        .map((time) => this.fromSQL(time.hour_name))[0]
    }

    static fromSQL(time) {
        return new Time(time.split("-")[0], time.split("-")[1])
    }
}

module.exports = {Time}