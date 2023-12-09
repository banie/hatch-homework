//
//  ContactImporter.swift
//  HatchHomework
//
//  Created by hatch.co
//

import Contacts

public class ContactImporter {
    public enum Error: Swift.Error {
        case alreadyImported
    }

    public static let shared = ContactImporter()
    
    /// This function will import a few hundred fictitious contacts into the system's address book.
    ///
    /// Contact data (json file) is computer generated.
    ///
    /// - Complexity: `O(n)`
    /// - Remark: Sets a flag in `UserDefaults.standard` after contacts are imported.
    /// - Throws: `ContactImporter.Error.alreadyImported` if flag exists in `UserDefaults.standard`
    /// - Warning: Since this function modifies the system Contacts, it is advised not to execute this function on a real iOS device or macOS device
    ///
    /// **SeeAlso:**
    ///
    /// Data was generated using [json-generator.com](https://www.json-generator.com/#) using this format
    ///
    ///     [
    ///       '{{repeat(300, 300)}}',
    ///       {
    ///         firstName: '{{firstName()}}',
    ///         lastName: '{{surname()}}',
    ///         email: '{{email()}}',
    ///         phone: '+1 {{phone()}}',
    ///         street: '{{integer(100, 999)}} {{street()}}',
    ///         city: '{{city()}}',
    ///         state: '{{state()}}',
    ///         zip: '{{integer(10000, 99999)}}'
    ///       }
    ///     ]
    public func importContactsFromJson() throws {
        // Prevent double importing.
        guard !Defaults.contactsImported() else {
            throw Error.alreadyImported
        }
        
        logger.debug("Will import contacts from json file.")
        let data = try Data(contentsOf: URL.contactsURL)
        let jsonContacts = try JSONDecoder().decode([JsonContact].self, from: data)
        let request = CNSaveRequest()
        jsonContacts
            .map { $0.cnContact }
            .forEach { request.add($0, toContainerWithIdentifier: nil) }
        try CNContactStore().execute(request)
        
        // Set flag to prevent double importing.
        Defaults.setContactsImported(true)
        
        logger.debug("Did import contacts from json file.")
    }
}

extension ContactImporter {
    public enum Defaults {
        private static let kImportKey = "ContactsImported"
        
        /// Returns true if contacts have been imported to iOS address book from json file.
        /// - Returns: Bool value
        public static func contactsImported() -> Bool {
            UserDefaults.standard.bool(forKey: kImportKey)
        }
        
        /// Sets a flag in UserDefaults
        /// - Parameter value: Bool value
        fileprivate static func setContactsImported(_ value: Bool) {
            UserDefaults.standard.setValue(value, forKey: kImportKey)
        }
    }
}

extension URL {
    fileprivate static var contactsURL: URL {
        guard let url = Bundle.module.url(
            forResource: "contacts",
            withExtension: "json"
        ) else {
            preconditionFailure("Invalid URL for contactsURL")
        }
        return url
    }
}

struct JsonContact: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let street: String
    let city: String
    let state: String
    let zip: Int
}

extension JsonContact {
    fileprivate var cnContact: CNMutableContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        
        if Int.chance(8, in: 10) {
            contact.familyName = lastName
        }
        
        if Int.chance(8, in: 10) {
            contact.phoneNumbers = [
                CNLabeledValue<CNPhoneNumber>(
                    label: "mobile",
                    value: CNPhoneNumber(stringValue: phone)
                )
            ]
        }
        
        if Int.chance(6, in: 10) {
            contact.emailAddresses = [
                CNLabeledValue<NSString>(
                    label: "home",
                    value: email as NSString
                )
            ]
        }
        
        if Int.chance(9, in: 10) {
            let address = CNMutablePostalAddress()
            address.street = street
            address.city = city
            address.state = state
            address.postalCode = "\(zip)"
            contact.postalAddresses = [
                CNLabeledValue<CNPostalAddress>(label: "home", value: address)
            ]
        }
        
        return contact
    }
}

extension Int {
    /// Think of this like setting the odds on a 2 sided dice.
    /// EX: `Int.chance(8, in: 10)` will return `true` approx 8 out of 10 times.
    static func chance(_ chance: Int, in count: Int) -> Bool {
        Int.random(in: 0..<count) % count < chance
    }
}
