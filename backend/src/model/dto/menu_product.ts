export interface MenuProduct {
    id?: number;
    name: string;
    description?: string;
    price: number;
    allergens: Allergen[];
}

export enum Allergen {
    cereals,
    crustaceans,
    eggs,
    fish,
    peanuts,
    soybeans,
    milk,
    nuts,
    celery,
    mustard,
    sesame,
    sulphurDioxide,
    lupin,
    molluscs,
}