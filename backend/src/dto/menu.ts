import { MenuProduct } from "./menu_product";

export interface RestaurantMenu {
    id?: number;
    title: string;
    published: boolean;
    categories: MenuCategory[];
}

export interface MenuCategory {
    id?: number;
    title: string;
    products: MenuProduct[];
}