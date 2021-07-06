class Room {
    name = ''

    constructor(name) {
        this.name = name;
    }

    static fromSQL(sqlOutput, roomId) {
        return new Room(sqlOutput["rooms"]
        .filter((room) => room.room_id == roomId)
        .map((room) => room.room_name)[0])
    }
}

module.exports = {Room}