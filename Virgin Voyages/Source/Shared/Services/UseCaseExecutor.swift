//
//  UseCaseExecutor.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 8.11.24.
//

import Foundation

class UseCaseExecutor<T> {
    static func execute(_ callback: @escaping () async throws -> T) async throws -> T {
		do {
			let result = try await callback()
			return result
		} catch (let error) as NetworkServiceError {
			throw NetworkToVVDomainErrorMapper.map(from: error)
		} catch (let error) as VVDomainError {
			throw error
        } catch (let error) {
			print(error)
			throw error
        }
    }
}
