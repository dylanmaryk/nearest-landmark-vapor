import Vapor

struct Result: Content {
    let position: [Double]
    let distance: Int
    let title: String
    let href: String
}
