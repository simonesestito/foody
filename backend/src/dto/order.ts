import { CartProduct } from "./cart_product";

export interface Order {
    id?: number;
    status: OrderStatus;
    products: CartProduct[];
}

export enum OrderStatus {
    preparing,
    prepared,
    delivering,
    delivered,
}