export interface Review {
    userId: number;
    restaurantId: number;
    creationDate: Date;
    mark: number,
    title?: string;
    description?: string;
}