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

// eslint-ignore-next-line @typescript-eslint/no-explicit-any
export async function dbSelect(query: string, values?: Array<string|number>): Promise<any[]> {
    return withConnection(conn => conn.query(query, values));
}

export async function dbInsert(query: string, values?: Array<string|number>): Promise<number> {
    return withConnection(async conn => {
        const result = await conn.query(query, values);
        // TODO: Handle errors
        return Number(result.insertId);
    });
}
