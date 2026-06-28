import Foundation

/// Provenance + rights record attached to every historical asset shown in
/// the app (CLAUDE.md §7). An asset missing any required field is blocked
/// from a production build by `EvidenceValidator`.
struct Evidence: Codable, Identifiable, Equatable {
    let id: String
    let expressionLevel: ExpressionLevel
    let sourceName: String
    let rightsStatus: RightsStatus
    /// Credit text. When credit is genuinely not required, this must be the
    /// explicit sentinel `Evidence.attributionNotRequired`, never empty.
    let attribution: String
    let permittedUses: [PermittedUse]
    /// Owner of the content (person/organisation). Required for production.
    let contentOwner: String
    /// When the rights were last reviewed. Required for production.
    let reviewedAt: Date
    /// Optional pointer into the access-controlled rights ledger.
    let permissionRecordID: String?
    /// Optional date by which rights must be re-reviewed; past = blocked.
    let reviewDueAt: Date?

    /// Sentinel meaning "credit not required" — distinct from a missing value.
    static let attributionNotRequired = "notRequired"
}
