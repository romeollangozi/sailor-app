//
//  LoadLocalizationUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//

protocol LoadLocalizationUseCaseProtocol {
    func execute(useCache: Bool) async
}

class LoadLocalizationUseCase: LoadLocalizationUseCaseProtocol {
    private let repository: ResourcesRepositoryProtocol
    private let diskStore: StringResourcesDiskStoreProtocol
    private let localizationManager: LocalizationManagerProtocol

    init(
        repository: ResourcesRepositoryProtocol,
        diskStore: StringResourcesDiskStoreProtocol,
        localizationManager: LocalizationManagerProtocol
    ) {
        self.repository = repository
        self.diskStore = diskStore
        self.localizationManager = localizationManager
    }

    func execute(useCache: Bool) async {
        do {
            let translations = try await repository.fetchStringResources(useCache: useCache)
            try diskStore.save(translations)
            localizationManager.setCustomTranslations(translations)
        } catch {
            if diskStore.fileExists(), let translations = try? diskStore.load() {
                localizationManager.setCustomTranslations(translations)
            } else {
                localizationManager.loadDefaults()
            }
        }
    }
}
