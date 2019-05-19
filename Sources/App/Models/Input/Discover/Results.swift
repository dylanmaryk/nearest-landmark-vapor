import Vapor

struct Results: Content {
    let items: [Result]
}
