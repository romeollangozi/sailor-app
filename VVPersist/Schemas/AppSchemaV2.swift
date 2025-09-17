//
//  AppSchemaV2.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 22.8.25.
//

import SwiftData

public typealias LineUpsDBModel = AppSchemaV2.LineUpsDBModel
public typealias LineUpHourDBModel = AppSchemaV2.LineUpHourDBModel
public typealias LineUpEventDBModel = AppSchemaV2.LineUpEventDBModel

public enum AppSchemaV2: VersionedSchema {
    public static var versionIdentifier: Schema.Version = Schema.Version(2, 0, 0)

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

extension AppSchemaV2 {
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
    public final class LineUpEventDBModel {
        public var name: String
        public var location: String
        public var timePeriod: String
        public var startDateTime: Date? = nil

        public init(name: String, location: String, timePeriod: String, startDateTime: Date? = nil) {
            self.name = name
            self.location = location
            self.timePeriod = timePeriod
            self.startDateTime = startDateTime
        }
    }
    
    @Model
    public final class LineUpHourDBModel {
        public var sequence: Int?
        public var time: String
        public var date: Date?
        public var lineUps: [LineUpEventDBModel] = []
        public var mustSeeLineUps: [LineUpEventDBModel] = []

        public init(sequence: Int? = nil, time: String, date: Date? = nil, lineUps: [LineUpEventDBModel] = [], mustSeeLineUps: [LineUpEventDBModel] = []) {
            self.sequence = sequence
            self.time = time
            self.date = date
            self.lineUps = lineUps
            self.mustSeeLineUps = mustSeeLineUps
        }
    }
}
