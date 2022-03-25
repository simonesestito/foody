export interface Address {
    address: string;
    houseNumber?: string;
    location: GpsLocation;
}

export interface GpsLocation {
    latitude: number;
    longitude: number;
}