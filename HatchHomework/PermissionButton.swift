//
//  PermissionButton.swift
//  HatchHomework
//
//  Created by hatch.co
//

import HatchContacts
import SwiftUI

struct PermissionButton: View {
    let title: String
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .buttonStyle(.bordered)
        .foregroundColor(foregroundColor)
    }
}

#Preview("PermissionButton") {
    PermissionButton(
        title: "Some Permission",
        foregroundColor: .cyan,
        action: {
            logger.debug("PermissionButton.onButtonPress")
        }
    )
}
