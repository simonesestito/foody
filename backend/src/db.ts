import mariadb from 'mariadb';

const connectionPool = mariadb.createPool({
    bigIntAsNumber: true,
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE,
    connectionLimit: Number.parseInt(process.env.MYSQL_CONNECTIONS),
});

async function withConnection<T>(action: (conn: mariadb.Connection) => Promise<T>): Promise<T> {
    const connection = await connectionPool.getConnection();
    try {
        return await action(connection);
    } finally {
        await connection.end();
    }
}

export namespace DB {
    export async function select(query: string) {
        return withConnection(conn => conn.query(query));
    }

    export async function insert(query: string, values?: Array<any>) {
        return withConnection(async conn => {
            const result = await conn.query(query, values);
            // TODO: Handle errors
            return Number(result.insertId);
        });
    }
}