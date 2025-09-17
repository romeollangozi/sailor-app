# Agents — Architecture & Code Guidelines

This project follows two complementary standards:

- Clean Code principles (Robert C. Martin)
- Clean Architecture with MVVM (Model–View–ViewModel)

The goal is to keep the codebase readable, testable, and evolvable, while making feature work predictable and safe.

## Clean Code Principles

- Meaningful names: prefer intention-revealing, domain language; avoid abbreviations.
- Small functions: do one thing, one level of abstraction per function.
- SRP everywhere: a class/type/module has a single reason to change.
- Expressive code > comments: remove dead code; write self-documenting code; comment “why”, not “what”.
- Fail fast: validate early; return/throw early; avoid deep nesting.
- Immutability by default: prefer `let` and value types; keep state localized.
- No magic numbers/strings: extract to typed models, enums, or constants.
- Consistent error handling: map infra errors to domain errors; avoid leaking transport-layer details upward.
- Side-effect isolation: pure functions for logic; side effects behind boundaries (repositories/services).
- DRY but pragmatic: duplicate narrowly if it reduces coupling; avoid premature abstraction.
- Formatting and style: match existing conventions; keep files focused and short.

## Clean Architecture + MVVM

Layered dependency rule: source code dependencies point inward only.

- Presentation (outer): SwiftUI Views, ViewModels, Coordinators. Depends on Domain via protocols/use cases.
- Domain (inner): Entities/Models, Use Cases, Repository/Service protocols. No platform or networking.
- Data (outer): Repository and Service implementations, DTOs, Mappers, Network/Persistence.

MVVM specifics:

- View: renders state, forwards user intents; no business logic.
- ViewModel: orchestrates use cases, exposes UI state; no platform APIs beyond presentation concerns.
- Use Cases: application-specific business rules; single entry `execute(...)` function.
- Repositories/Services: protocol-first; implementations live in Data and hide networking/storage details.

### Dependency Injection

- Depend on protocols; inject via initializers. Provide light defaults for convenience, but prefer explicit injection in composition roots.
- Boundaries (networking, storage, notifications) are accessed via protocol abstractions.

### Errors

- Domain defines error types (e.g., `VVDomainError`). Data maps transport errors to domain errors. Presentation converts domain errors to user-facing messages.

## Project Structure

Per feature, keep a vertical slice with three submodules:

```
Virgin Voyages/Source/Features/<Feature>/
  Domain/
    Models/
    UseCases/
    Repositories/  (protocols)
    Services/      (protocols)
    Mappers/       (domain <-> dto)
  Data/
    *.DTO.swift
    Repositories/  (impl)
    Services/      (impl)
  Presentation/
    ViewModels/
    Views/
    Coordinator/
```

Keep shared cross-cutting concerns under `Source/Shared/` with the same boundaries (Domain/Data/Presentation) when applicable.

## Conventions

- Protocols: suffix with `Protocol` (e.g., `TokenRepositoryProtocol`).
- Use cases: suffix `UseCase` and expose `func execute(...)` (async when appropriate).
- Repositories/Services: protocols in Domain, concrete implementations in Data.
- ViewModels: `@Observable` or equivalent; expose computed properties for UI enablement and derived state.
- Navigation: handled via Coordinators; ViewModels request navigation through coordinator commands.
- Async: prefer async/await; avoid escaping completion handlers in new code unless required by SDK.
- Events: publish cross-cutting app events through notification services (domain events) rather than tight coupling.

## Testing

- All code generated should be testable and have unit tests created
- All unit tests live inside the Virgin VoyagesTests target / folder
- Unit tests at Use Case and ViewModel layers using protocol-driven mocks.
- Data layer tests focus on mapping (DTO <-> Model) and request building.
- Name tests Given_When_Then; keep one logical assertion per test (multiple physical asserts allowed).
- Prefer deterministic tests; isolate the clock, random, and IO behind protocols.

## Templates (Swift)

Use Case

```swift
protocol <Name>UseCaseProtocol {
    associatedtype Output
    func execute(_ input: <Input>) async throws -> Output
}

final class <Name>UseCase: <Name>UseCaseProtocol {
    private let repository: <DependencyProtocol>
    init(repository: <DependencyProtocol> = <DependencyImpl>()) {
        self.repository = repository
    }
    func execute(_ input: <Input>) async throws -> Output {
        // orchestrate domain logic here
    }
}
```

Repository (Domain + Data)

```swift
// Domain
protocol <Thing>RepositoryProtocol {
    func fetch(id: String) async throws -> <Thing>
}

// Data
final class <Thing>Repository: <Thing>RepositoryProtocol {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkService.create()) {
        self.network = network
    }
    func fetch(id: String) async throws -> <Thing> {
        let dto: <ThingDTO> = try await network.request(<Endpoint>())
        return dto.toDomain()
    }
}
```

ViewModel

```swift
@Observable final class <Feature>ViewModel {
    private let useCase: <Name>UseCaseProtocol
    init(useCase: <Name>UseCaseProtocol = <Name>UseCase()) { self.useCase = useCase }

    var isLoading = false
    var state: State = .idle

    func onAppear() { /* optional */ }

    func actionTriggered() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do { state = .loaded(try await useCase.execute(/* input */)) }
            catch { state = .error(map(error)) }
        }
    }
}
```

Mapping

```swift
extension <ThingDTO> {
    func toDomain() -> <Thing> { /* map fields safely */ }
}
```

## Acceptance Checklist

- Code adheres to Clean Code principles above.
- Dependencies point inward; domain is platform-agnostic.
- New features follow the Feature/Domain–Data–Presentation layout.
- Use cases have clear inputs/outputs and unit tests.
- Presentation contains no network/storage logic.
- Data layer does not leak DTOs or transport errors outside.
- PRs are small and focused: one logical change per PR; don’t mix refactors with behavior changes. Aim for review-friendly diffs (≈200–400 net LOC excluding tests/lockfiles), keep file count reasonable (≲10 when feasible), and include tests with the change.
- Iterative delivery: land features as a sequence of self-contained steps (interfaces/models → mappers/DTOs → repositories/services → use cases → view models → views). Each step compiles and passes tests. Commit messages and PR descriptions explain why, what, how tested, and risk/rollback.

## Checklist

- Single responsibility PR (no unrelated refactors/renames)
- Net diff ≈200–400 LOC (tests/locks excluded) and ≲10 files (when practical)
- Tests included/updated and green; each commit builds
- PR description covers context, test evidence (screenshots for UI), and follow-ups
