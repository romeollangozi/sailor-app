//
//  FolioDependentSailor.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 29.8.25.
//

public struct FolioDependentSailor: Identifiable {
    public let id: UUID = UUID()
    public let name: String
    public let status: String
    public let description: String
    public let instructions: String
    public let imageURL: URL?
    
    public init(name: String, status: String, description: String, instructions: String, imageURL: URL? = nil) {
        self.name = name
        self.status = status
        self.description = description
        self.instructions = instructions
        self.imageURL = imageURL
    }
}
