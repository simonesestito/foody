export type TimeOfDay = string; // Format: HH:mm:ss

export interface OpeningHours {
    weekday: number;
    openingTime: TimeOfDay;
    closingTime: TimeOfDay;
}