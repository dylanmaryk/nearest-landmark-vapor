import Vapor

final class LandmarksController {
    private static let hereApiUrl = "https://places.cit.api.here.com/places/v1/discover/explore?app_id=%@&app_code=%@&in=%@,%@;r=500&cat=sights-museums&show_content=wikipedia"
    
    func get(_ req: Request) throws -> Future<LandmarksWrapper> {
        guard let lat = req.query[String.self, at: "lat"],
            let lng = req.query[String.self, at: "lng"] else {
                throw Abort(.badRequest)
        }
        guard let hereAppId = Environment.get("here-app-id"),
            let hereAppCode = Environment.get("here-app-code") else {
                throw Abort(.internalServerError)
        }
        let url = String(format: LandmarksController.hereApiUrl, hereAppId, hereAppCode, lat, lng)
        let res = try req.client().get(url)
        let resultsWrapper = res.flatMap(to: ResultsWrapper.self) { res in
            try res.content.decode(ResultsWrapper.self)
        }
        let landmarksWrapper = resultsWrapper.map(to: LandmarksWrapper.self) { resultsWrapper in
            let landmarks = resultsWrapper.results.items
                .map { Landmark(position: Position(lat: $0.position[0],
                                                   lng: $0.position[1]),
                                distance: $0.distance,
                                title: $0.title) }
                .sorted { $0.distance < $1.distance }
            return LandmarksWrapper(landmarks: landmarks)
        }
        return landmarksWrapper
    }
}
