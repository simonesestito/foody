import { Address } from "./address";
import { RestaurantMenu } from "./menu";
import { OpeningHours } from "./opening_hours";

export interface Restaurant {
    id: number;
    name: string;
    address: Address;
    phoneNumbers: string[];
    openingHours: OpeningHours[];
    averageRating: number;
}

export interface DetailedRestaurant {
    restaurant: Restaurant;
    menus: RestaurantMenu[];
}