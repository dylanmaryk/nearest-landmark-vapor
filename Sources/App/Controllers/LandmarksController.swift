import Vapor

final class LandmarksController {
    private static let hereApiUrl = "https://places.cit.api.here.com/places/v1/discover/explore?app_id=%@&app_code=%@&in=%@,%@;r=500&cat=sights-museums&size=1&show_content=wikipedia"
    
    func get(_ req: Request) throws -> Future<LandmarksWrapper> {
        guard let lat = req.query[String.self, at: "lat"],
            let lng = req.query[String.self, at: "lng"] else {
                throw Abort(.badRequest)
        }
        guard let hereAppId = Environment.get("here-app-id"),
            let hereAppCode = Environment.get("here-app-code") else {
                throw Abort(.internalServerError)
        }
        let url = String(format: LandmarksController.hereApiUrl, arguments: [hereAppId, hereAppCode, lat, lng])
        let res = try req.client().get(url)
        return res
            .flatMap(to: ResultsWrapper.self) { res in
                try res.content.decode(ResultsWrapper.self)
            }
            .flatMap(to: [(Place, Result)].self) { resultsWrapper in
                try resultsWrapper.results.items
                    .map { result -> Future<(Place, Result)> in
                        let res = try req.client().get(result.href)
                        return res
                            .flatMap(to: Place.self) { res in
                                try res.content.decode(Place.self)
                            }
                            .and(result: result)
                    }
                    .flatten(on: req)
            }
            .map {
                let landmarks = $0
                    .map { self.landmark(for: $0.0, and: $0.1) }
                    .sorted { $0.distance < $1.distance }
                return LandmarksWrapper(landmarks: landmarks)
        }
    }
    
    private func landmark(for place: Place, and result: Result) -> Landmark {
        return Landmark(position: Position(lat: result.position[0],
                                           lng: result.position[1]),
                        distance: result.distance,
                        title: result.title)
    }
}
