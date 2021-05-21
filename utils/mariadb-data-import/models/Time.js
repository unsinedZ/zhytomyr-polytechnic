class Time {
    static fromTimeId(sqlOutput, timeId) {
        return sqlOutput["hours"].filter((time) => time.hour_id == timeId)
        .map((time) => this.fromSQL(time.hour_name))[0]
    }

    static fromSQL(time) {
        return {
            "start": time.split("-")[0],
            "end": time.split("-")[1]
        }
    }
}

module.exports = {Time}