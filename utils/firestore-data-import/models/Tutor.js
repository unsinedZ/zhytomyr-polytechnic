class Tutor {
    static defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/zhytomyr-politechnic-dev.appspot.com/o/images%2Fusers%2Fdefault-photo.png?alt=media&token=78fb2698-633b-4a02-a3e4-5fd754ba75cb";

    id = 0
    name = ''
    imageUrl = ''

    constructor(id, name, imageUrl) {
        this.id = id;
        this.name = name;
        this.imageUrl = imageUrl;
    }

    static fromTutorId(sqlOutput, tutorId) {
        return sqlOutput["teachers"]
            .filter((teacher) => teacher.teacher_id == tutorId)
            .map((tutor) => {
                return Tutor.fromSQL(tutor)
            })
    }

    static fromSQL(tutor) {
        return new Tutor(tutor.teacher_id, tutor.teacher_name, this.defaultAvatar)
    }

}

module.exports = {
    Tutor
}