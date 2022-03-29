import { RequestHandler } from 'express';

/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable no-loops/no-loops */

export function wrapRoute(action: RequestHandler): RequestHandler {
    return (async (req, res, next) => {
        try {
            // run controllers logic
            await action(req, res, next);
        } catch (e) {
            res.status(500).send({
                error: e.toString(),
            });

            console.error(e, e.toString());
            if (process.env.NODE_ENV === 'development')
                throw e;
        }
    });
}

export type DictKey = string | number | symbol;

export type Dict<V> = {
    [key: DictKey]: V;
};

export function mapGroup<R>(
    list: any[],
    key: (e: any) => DictKey,
    groupMappers: Dict<(e: any) => any>,
    join: (id: DictKey, parts: Dict<any>) => R,
): R[] {
    const rowsById = {};

    for (const row of list) {
        const id = key(row);
        if (!(id in rowsById)) {
            rowsById[id] = {};
        }

        const groups = rowsById[id];
        for (const [groupKey, groupMapper] of Object.entries(groupMappers)) {
            if (!(groupKey in groups)) {
                groups[groupKey] = new ObjectSet();
            }

            groups[groupKey].add(groupMapper(row));
        }
    }

    // Map from Set to lists
    for (const groups of Object.values(rowsById)) {
        for (const [groupKey, group] of Object.entries(groups)) {        
            groups[groupKey] = group.toArray();
        }
    }

    const resultObjects: R[] = [];
    for (const [id, groups] of Object.entries(rowsById)) {
        resultObjects.push(join(id, groups));
    }
    return resultObjects;
}

export class ObjectSet {
    private backingDict: Dict<any> = {};

    add(object: any) {
        this.backingDict[JSON.stringify(object)] = object;
    }

    toArray() {
        return Object.values(this.backingDict);
    }
}
