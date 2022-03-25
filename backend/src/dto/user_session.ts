export interface UserSession {
    token: string;
    userAgent: string;
    lastIpAddress: string;
    creationDate: Date;
    lastUsageDate: Date;
    isCurrent: boolean;
}