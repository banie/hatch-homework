//
//  Contact.swift
//  HatchHomework
//
//  Created by hatch.co
//

import Contacts

public struct Contact: Hashable, Identifiable {
    public var id: String { identifier }
    public let identifier: String
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: CNLabeledValue<NSString>?
    public var postalAddress: CNLabeledValue<CNPostalAddress>?
    public var phoneNumber: CNLabeledValue<CNPhoneNumber>?
}

extension Contact {
    /// Returns first and last name joined into a single string.
    /// EX: "John Smith"
    public var name: String {
        [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
    /// Returns a formatted postal address if `postalAddress` can be formatted as such.
    public var postalAddressDescription: String? {
        guard let postalAddress = postalAddress?.value else { return nil }
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: postalAddress)
    }
}

extension Contact {
    public static func placeholder() -> Contact {
        let emailAddress = CNLabeledValue<NSString>(
            label: "home",
            value: "bob@smith.com"
        )
        
        let postalAddress = CNLabeledValue<CNPostalAddress>(
            label: "home",
            value: {
                let address = CNMutablePostalAddress()
                address.street = "123 Fake St."
                address.city = "Parts Unknown"
                address.state = "Nevada"
                address.postalCode = "\(12345)"
                return address
            }()
        )
        
        let phoneNumber = CNLabeledValue<CNPhoneNumber>(
            label: "home",
            value: CNPhoneNumber(stringValue: "123-456-7890")
        )
        
        return Contact(
            identifier: UUID().uuidString,
            firstName: "Bob",
            lastName: "Smith",
            emailAddress: emailAddress,
            postalAddress: postalAddress,
            phoneNumber: phoneNumber
        )
    }
}
