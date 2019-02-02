import Vapor

struct Item: Content {
    let position: [Double]
    let distance: Int
    let title: String
}
