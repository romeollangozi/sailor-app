//
//  VVPersist.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/18/25.
//

import SwiftData

public enum VVPersistError: Error {
	case failedToSave
}

public final class VVContextSession {
	private let context: ModelContext

	public init(container: ModelContainer) {
		self.context = ModelContext(container)
	}

	public func perform(_ block: (ModelContext) throws -> Void) rethrows {
		try block(context)
	}

	public func fetchAll<T: PersistentModel>() -> [T] {
		let descriptor = FetchDescriptor<T>()
		do {
			return try context.fetch(descriptor)
		} catch {
			return []
		}
	}

	public func insert<T: PersistentModel>(_ model: T) {
		context.insert(model)
	}

	public func delete<T: PersistentModel>(_ model: T) {
		context.delete(model)
	}

	public func save() throws {
		do {
			try context.save()
		} catch {
			throw VVPersistError.failedToSave
		}
	}
}

public class VVDatabase {
	public static let shared = VVDatabase()
	private let container: ModelContainer

	private init() {
		do {
            let schema = Schema(versionedSchema: AppSchemaV2.self)
            container = try ModelContainer(for: schema, migrationPlan: AppMigrationPlan.self)
		} catch {
			fatalError("Failed to initialize SwiftData: \(error)")
		}
	}

	public func createSession() -> VVContextSession {
		return VVContextSession(container: container)
	}
}
