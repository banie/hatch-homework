//
//  ContactManager.swift
//  HatchHomework
//
//  Created by hatch.co
//

import Contacts

@Observable
public class ContactManager {
    // MARK: Public static vars
    
    public static let shared = ContactManager()
    
    // MARK: Public vars
    public private(set) var isLoading: Bool = false
    public private(set) var contacts: [Contact] = [] {
        didSet {
            logger.debug("Did load \(self.contacts.count) contacts")
        }
    }
    
    public var authorizationStatus: AuthorizationStatus = .notDetermined
    
    // MARK: Private vars
    
    private let store = CNContactStore()
    
    private var mappedAuthorizationStatus: AuthorizationStatus {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined: .notDetermined
        case .authorized: .authorized
        default: .unauthorized
        }
    }
    
    private init() {
        self.authorizationStatus = mappedAuthorizationStatus
        self.contacts = loadPlaceholderContacts()
    }
    
    public func requestAuthorization(
        completion: ((_ status: AuthorizationStatus) -> Void)? = nil
    ) {
        store.requestAccess(
            for: .contacts
        ) { [weak self] _, error in
            guard let self else { return }
            if let error {
                logger.fault("Failed to request access to Contacts: \(error.localizedDescription)")
            }
            authorizationStatus = mappedAuthorizationStatus
            completion?(authorizationStatus)
        }
    }
    
    public func loadContacts() async throws {
        isLoading = true
        contacts = []
        let keysToFetch = [CNContactIdentifierKey,
                           CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactEmailAddressesKey,
                           CNContactPostalAddressesKey,
                           CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        try store.enumerateContacts(with: fetchRequest, usingBlock: { (cnContact, stop) in
            isLoading = false
            let newContact = Contact(identifier: cnContact.identifier,
                                     firstName: cnContact.givenName,
                                     lastName: cnContact.familyName,
                                     emailAddress: cnContact.emailAddresses.first,
                                     postalAddress: cnContact.postalAddresses.first,
                                     phoneNumber: cnContact.phoneNumbers.first)
            contacts.append(newContact)
        })
    }

    private func loadPlaceholderContacts() -> [Contact] {
        [Contact.placeholder()]
    }
}
