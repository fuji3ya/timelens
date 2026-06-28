import Foundation

/// The safe place a user stands to view a spot, plus the direction to aim
/// the camera. The experience is never meant to be used while walking
/// (CLAUDE.md §8 安全UX).
struct ViewingPoint: Codable, Equatable {
    let coordinate: Coordinate
    /// Compass heading (degrees, 0 = north) the camera should face.
    let headingDegrees: Double?
    /// Short guidance shown to the user ("歩道の角に立ち、駅の方向を向く" など).
    let guidance: String
    /// Optional bundled image name illustrating where to stand.
    let guideImageName: String?
}
