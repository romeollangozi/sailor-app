//
//  AppSchemaV1.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/17/25.
//

import SwiftData

public enum AppSchemaV1: VersionedSchema {
    public static var versionIdentifier: Schema.Version = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [
            MyAgendaDBModel.self,
            MyAgendaBookingDBModel.self,
            ShipTimeDBModel.self,
            AllAboardTimesDBModel.self,
            AllAboardTimeDBModel.self,
            LineUpsDBModel.self,
            LineUpHourDBModel.self,
            LineUpEventDBModel.self,
            CacheDataDbModel.self
        ]
    }
}


extension AppSchemaV1 {
    @Model
    public final class LineUpEventDBModel {
        public var name: String
        public var location: String
        public var timePeriod: String

        public init(name: String, location: String, timePeriod: String) {
            self.name = name
            self.location = location
            self.timePeriod = timePeriod
        }
    }
    
    @Model
    public class LineUpsDBModel {
        public var lastUpdated: Date
        public var lineUpHours: [LineUpHourDBModel] = []

        public init(lastUpdated: Date = Date(), lineUpHours: [LineUpHourDBModel] = []) {
            self.lastUpdated = lastUpdated
            self.lineUpHours = lineUpHours
        }
    }
    
    @Model
    public final class LineUpHourDBModel {
        public var sequence: Int?
        public var time: String
        public var date: Date?
        public var lineUps: [LineUpEventDBModel]

        public init(sequence: Int? = nil, time: String, date: Date? = nil, lineUps: [LineUpEventDBModel]) {
            self.sequence = sequence
            self.time = time
            self.date = date
            self.lineUps = lineUps
        }
    }
}
