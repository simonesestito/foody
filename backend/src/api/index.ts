import express from 'express';
import { restaurantRouter } from './restaurant';

export const apiRouter = express.Router();
apiRouter.use('/restaurant', restaurantRouter);