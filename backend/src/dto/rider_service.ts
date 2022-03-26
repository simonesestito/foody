import { GpsLocation } from './address';
import { Order } from './order';

export interface RiderService {
    id?: number;
    startLocation: GpsLocation;
    lastLocation: GpsLocation;
    start: Date;
    end?: Date;
    orders: Order[];
}