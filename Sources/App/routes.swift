import Vapor

public func routes(_ router: Router) throws {
    let landmarksController = LandmarksController()
    router.get("landmarks", use: landmarksController.get)
}
