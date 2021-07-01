const opts = require('optimist').argv
const writeJsonFile = require('write-json-file');
const mariadb = require('mariadb');
const {exit} = require('process');

(async () => {
    let result = {};

    const connection = await mariadb.createPool({
        host: !opts.host ? '127.0.0.1' : opts.host,
        user: !opts.user ? "root" : opts.user,
        password: !opts.password ? "root" : opts.password,
        connectionLimit: 5,
    }).getConnection();

    const databases = (await connection.query("SHOW DATABASES")).map((database) => database.Database);

    if (!opts.database) {
        throw Error("Database param is empty");
    }

    if ((databases.filter((database) => opts.database == database)).length == 0) {
        throw Error("Database doesnt exist");
    }

    await connection.query("USE " + opts.database);

    if (!opts.query) {
        const tables = (await connection.query("SHOW TABLES")).map((item) => Object.values(item)[0]);
        await tables.forEach(async (table) => {
            const initTable = (await connection.query("SELECT * FROM " + table))

            result[table] = initTable.map((ent) => Object.entries(ent)).map((entities) => entities.map((entity) => {
                entity[0] = entity[0].replace(table + "_", "");
                return entity
            })).map((entities) => Object.fromEntries(entities));
        })
    }
    await writeJsonFile(!opts.output ? "output.json" : opts.output, result);

    connection.end()

    console.log('Successfully wrote file')
    exit(0);

})().catch((error) => {
    console.error("Error: " + error.message);
    exit(1);
});