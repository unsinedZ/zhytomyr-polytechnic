class Subject {
    name = '';

    constructor(name) {
        this.name = name
    }

    static fromSQL(sqlOutput, subjectId) {
        return new Subject(sqlOutput["subjects"]
            .filter((subject) => subject.subject_id == subjectId)
            .map((subject) => subject.subject_name)[0])
    }
}

module.exports = {
    Subject
}