// See https://github.com/simonesestito/foody/blob/main/webapp/lib/data/api/restaurants.dart

import { dbSelect } from '../db';
import { Address, GpsLocation } from '../dto/address';
import { DetailedRestaurant, Restaurant } from '../dto/restaurant';
import express from 'express';
import { mapGroup, wrapRoute } from '../utils';
import { RestaurantMenu } from '../dto/menu';

export const restaurantRouter = express.Router();

async function getNearRestaurants(location: GpsLocation, query?: string): Promise<Restaurant[]> {
    if (!query) query = '';
    query = `%${query}%`;

    const dbResult = await dbSelect(`
SELECT * FROM RestaurantDetails
WHERE name LIKE ?
ORDER BY DISTANCE_KM(?, ?, address_latitude, address_longitude)
`, [query, location.latitude, location.longitude]);

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
            openingHours: row => ({
                weekday: row.weekday,
                openingTime: row.opening_time,
                closingTime: row.closing_time,
            }),
        },
        (id, parts) => ({
            id: Number.parseInt(id.toString()),
            name: parts.restaurant[0].name,
            address: parts.address[0],
            openingHours: parts.openingHours,
            averageRating: parts.restaurant[0].averageRating,
            phoneNumbers: parts.phoneNumbers,
        })
    );
}

/* TODO async function getRestaurant(id: number): Promise<DetailedRestaurant> {
    const dbResult = await dbSelect(`
SELECT *
FROM RestaurantsWithMenu
WHERE menu_published = TRUE AND id = ?`, [id]);

const menus = mapGroup<RestaurantMenu>(
    dbResult,
    row => row.menu_id,
    {
        
    },
    (menuId, parts) => ({

    }),
);

    return mapGroup<DetailedRestaurant>(
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
            openingHours: row => ({
                weekday: row.weekday,
                openingTime: row.opening_time,
                closingTime: row.closing_time,
            }),
            menus: row => ({

            });
        },
        (id, parts) => ({
            restaurant: {
                id: Number.parseInt(id.toString()),
                name: parts.restaurant[0].name,
                address: parts.address[0],
                openingHours: parts.openingHours,
                averageRating: parts.restaurant[0].averageRating,
                phoneNumbers: parts.phoneNumbers,
            },
            menus: parts.menu
        })
    )[0];
} */

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
