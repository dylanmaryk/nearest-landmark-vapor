import Vapor

struct Results: Content {
    let items: [Item]
}
