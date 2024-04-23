import Foundation

enum APIError: Error{
    case invalidUrl, requestError, decodingError, statusNotOk
}

class PopularMoviesService {
    
    func getListOfPopularMovies() async throws -> [PopularMovie.Movie] {
        
        let (data, response) = try await URLSession.shared.data(for: returnRequest())
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.statusNotOk
        }
        
        guard let result = try? JSONDecoder().decode([PopularMovie.Movie].self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func returnRequest() -> URLRequest {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMmNlM2Q3ZDIwODNjMjA4NTBhNDNjYzRmY2ZmZTNiMiIsInN1YiI6IjYxMjk3MWRmNDJmMTlmMDA5NTc2ZmFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h3D0kylycVezUE9fQi3k4UQp5_NrY7ExrjsVGyNgLH4"
        ]
        
        return request
    }
}
