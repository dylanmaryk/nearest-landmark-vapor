import Vapor

struct Landmark: Content {
    let position: Position
    let distance: Int
    let title: String
    let images: [Image]
    let editorial: Editorial?
}
