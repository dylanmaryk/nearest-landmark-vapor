import Vapor

typealias Result = Item

struct Item: Content {
    let position: [Double]
    let distance: Int
    let title: String
    let href: String
}
