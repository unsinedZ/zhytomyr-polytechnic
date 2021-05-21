class Subject {
    static fromSQL(sqlOutput, subjectId) {
        return sqlOutput["subjects"]
                .filter((subject) => subject.subject_id == subjectId)
                .map((subject) => subject.subject_name)[0]
    }
}

module.exports = {Subject}