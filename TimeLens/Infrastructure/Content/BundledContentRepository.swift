import Foundation

/// Loads content from a JSON file inside the app bundle (CLAUDE.md §4, §10).
/// V1 ships entirely from the bundle — no network required for first run.
struct BundledContentRepository: ContentRepository {
    // Only Sendable state (Strings) is stored so the repository is Sendable.
    // The bundle is resolved at call time via `Bundle.main`.
    private let resourceName: String
    private let resourceExtension: String

    init(
        resourceName: String = "routes",
        resourceExtension: String = "json"
    ) {
        self.resourceName = resourceName
        self.resourceExtension = resourceExtension
    }

    func loadRoutes(productionSafeOnly: Bool) async throws -> [Route] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: resourceExtension) else {
            Log.content.error("Content resource not found: \(resourceName).\(resourceExtension, privacy: .public)")
            throw ContentError.missingResource(name: "\(resourceName).\(resourceExtension)")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            Log.content.error("Failed to read content data: \(error.localizedDescription, privacy: .public)")
            throw ContentError.missingResource(name: "\(resourceName).\(resourceExtension)")
        }

        let routes = try Self.decodeRoutes(from: data)
        let result = productionSafeOnly ? EvidenceValidator.productionSafe(routes) : routes

        if productionSafeOnly && result.isEmpty {
            Log.content.error("No publishable content after rights validation")
            throw ContentError.noPublishableContent
        }
        return result
    }

    /// Pure decode step, isolated so it can be unit-tested without a bundle.
    /// Decodes a `{ "routes": [...] }` document. Never crashes — a malformed
    /// document throws `ContentError.decodingFailed` (CLAUDE.md §10 完了条件).
    static func decodeRoutes(from data: Data) throws -> [Route] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(ContentDocument.self, from: data).routes
        } catch let error as DecodingError {
            throw ContentError.decodingFailed(reason: Self.describe(error))
        } catch {
            throw ContentError.decodingFailed(reason: error.localizedDescription)
        }
    }

    /// Top-level shape of routes.json.
    private struct ContentDocument: Codable {
        let routes: [Route]
    }

    private static func describe(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, let ctx):
            return "missing key '\(key.stringValue)' at \(path(ctx))"
        case .typeMismatch(_, let ctx):
            return "type mismatch at \(path(ctx)): \(ctx.debugDescription)"
        case .valueNotFound(_, let ctx):
            return "missing value at \(path(ctx))"
        case .dataCorrupted(let ctx):
            return "data corrupted at \(path(ctx)): \(ctx.debugDescription)"
        @unknown default:
            return "unknown decoding error"
        }
    }

    private static func path(_ ctx: DecodingError.Context) -> String {
        ctx.codingPath.map(\.stringValue).joined(separator: ".")
    }
}
