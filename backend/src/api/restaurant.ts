// See https://github.com/simonesestito/foody/blob/main/webapp/lib/data/api/restaurants.dart

import { dbSelect } from '../db';
import { Address, GpsLocation } from '../dto/address';
import { Restaurant } from '../dto/restaurant';
import express from 'express';
import { mapGroup, wrapRoute } from '../utils';

export const restaurantRouter = express.Router();

async function getNearRestaurants(location: GpsLocation, query?: string): Promise<Restaurant[]> {
    if (!query) query = '';
    query = `%${query}%`;

    const dbResult = await dbSelect(`
SELECT Restaurant.*,
       OpeningHours.opening_time,
       OpeningHours.closing_time,
       OpeningHours.weekday,
       RestaurantPhone.phone,
       R.average_rating
FROM Restaurant
         RIGHT JOIN OpeningHours ON Restaurant.id = OpeningHours.restaurant
         LEFT JOIN RestaurantPhone on Restaurant.id = RestaurantPhone.restaurant
         LEFT JOIN (
    SELECT Restaurant.id, AVG(Review.mark) as average_rating
    FROM Restaurant
             LEFT JOIN Review on Restaurant.id = Review.restaurant
) R ON Restaurant.id = R.id
WHERE name LIKE ?
ORDER BY DISTANCE_KM(?, ?, address_latitude, address_longitude)
LIMIT 50`, [query, location.latitude, location.longitude]);

    return mapGroup<Restaurant>(
        dbResult,
        row => row.id,
        {
            restaurant: row => ({
                name: row.name,
                averageRating: row.average_rating,
            }),
            address: row => ({
                address: row.address_street,
                houseNumber: row.address_house_number,
                city: row.address_city,
                location: {
                    latitude: row.address_latitude,
                    longitude: row.address_longitude,
                }
            } as Address),
            phoneNumbers: row => row.phone,
        },
        (id, parts) => ({
            id: id as number,
            name: parts.restaurant[0].name,
            address: parts.address,
            openingHours: parts.openingHours,
            averageRating: parts.restaurant[0].averageRating,
            phoneNumbers: parts.phoneNumbers,
        })
    );
}

restaurantRouter.get('/', wrapRoute(async (req, res) => {
    const location: GpsLocation = {
        latitude: Number.parseFloat(req.query.latitude?.toString()),
        longitude: Number.parseFloat(req.query.longitude?.toString()),
    };
    const query: string = req.query.query?.toString();
    if (isNaN(location.latitude) || isNaN(location.longitude)) {
        res.sendStatus(400);
    } else {
        res.send(await getNearRestaurants(location, query));
    }
}));
