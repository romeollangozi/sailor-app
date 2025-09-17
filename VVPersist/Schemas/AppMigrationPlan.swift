//
//  AppMigrationPlan.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 22.8.25.
//

import SwiftData

struct AppMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        AppSchemaV1.self,
        AppSchemaV2.self
    ]

    static var stages: [MigrationStage] = [
        .lightweight(fromVersion: AppSchemaV1.self, toVersion: AppSchemaV2.self)
    ]
}
