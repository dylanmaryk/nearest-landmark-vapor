import Vapor

struct Editorial: Content {
    let description: String
    let via: Via
    let attribution: String
}
