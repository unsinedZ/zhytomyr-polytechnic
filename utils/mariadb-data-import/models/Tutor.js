class Tutor {
    static defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/zhytomyr-politechnic-dev.appspot.com/o/images%2Fusers%2Fdefault-photo.png?alt=media&token=78fb2698-633b-4a02-a3e4-5fd754ba75cb";

    static fromTutorId(sqlOutput, tutorId) {
        return sqlOutput["teachers"]
        .filter((teacher) => teacher.teacher_id == tutorId)
        .map((tutor) => {
            return Tutor.fromSQL(tutor)
        })
    }

    static fromSQL(tutor) 
    {
        return {
            id: tutor.teacher_id,
            imageUrl: this.defaultAvatar,
            name: tutor.teacher_name
        }
    }

}

module.exports = {Tutor}