class Type {

    static fromSql(sqlOutput, tagId) {
        return sqlOutput["activities_tags"]
            .filter((tag) => tag.activity_tag_id == tagId)
            .map((tag) => tag.activity_tag_name)[0]
    }
}

module.exports = {Type}