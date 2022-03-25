import { RequestHandler } from "express";

export function wrapRoute(action: RequestHandler): RequestHandler {
    return (async (req, res, next) => {
        try {
            // run controllers logic
            await action(req, res, next);
        } catch (e) {
            res.status(500).send({
                error: e.toString(),
            });
        }
    });
}