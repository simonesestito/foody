export interface User {
    id: number;
    name: string;
    surname: string;
    emailAddresses: string[];
    phoneNumbers: string[];
    allowedRoles: UserRole[];
}

export interface NewUser {
    name: string;
    surname: string;
    emailAddress: string;
    password: string;
    phoneNumber: string;
}

export enum UserRole {
    customer,
    manager,
    admin,
    rider,
}