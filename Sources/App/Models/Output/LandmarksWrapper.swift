import Vapor

struct LandmarksWrapper: Content {
    let landmarks: [Landmark]
}
