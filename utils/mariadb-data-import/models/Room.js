class Room {
    static fromSQL(sqlOutput, roomId) {
        return sqlOutput["rooms"]
        .filter((room) => room.room_id == roomId)
        .map((room) => room.room_name)[0]
    }
}

module.exports = {Room}