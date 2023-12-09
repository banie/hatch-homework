//
//  AuthorizationStatus.swift
//
//  Created by hatch.co
//

public enum AuthorizationStatus: String, Identifiable {
    public var id: String { rawValue }
    case notDetermined
    case authorized
    case unauthorized
}

extension AuthorizationStatus: CustomStringConvertible {
    public var description: String { rawValue }
}
