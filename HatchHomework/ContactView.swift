//
//  ContactView.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI

struct ContactView: View {
    @State var contact: Contact
    
    @State private var distanceContainer: (any DistanceRepresentable)?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("\(contact.name)")
                .font(.body)
                .italic()
            
            if let postalAddressDescription = contact.postalAddressDescription {
                Text("\(postalAddressDescription)")
                    .font(.callout)
            }
            
            #warning("TODO: Implement Functional Requirement #2 (from README.md)")
            Text("Distance: Implement Me!\ndistanceContainer.distance(...)")
                .font(.callout)
                .foregroundColor(.red)
                        
            Text("\(contact.identifier)")
                .font(.caption2)
        }
    }
}

#Preview("ContactView") {
    ContactView(contact: .placeholder())
}
