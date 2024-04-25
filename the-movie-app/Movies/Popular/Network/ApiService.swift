import Foundation

enum Endpoint {
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        }
    }
}

enum ResponseType {
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    
    var objectType: Decodable.Type {
        switch self {
        case .popularMovies:
            return PopularMovie.self
        case .topRatedMovies:
            return TopRatedMovie.self
        case .upcomingMovies:
            return UpcomingMovie.self
        }
    }
}

class ApiService {
    private let baseURL = "https://api.themoviedb.org/3"
    
    func request<T: Decodable>(endpoint: Endpoint,  responseType: ResponseType) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMmNlM2Q3ZDIwODNjMjA4NTBhNDNjYzRmY2ZmZTNiMiIsInN1YiI6IjYxMjk3MWRmNDJmMTlmMDA5NTc2ZmFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.h3D0kylycVezUE9fQi3k4UQp5_NrY7ExrjsVGyNgLH4"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.statusNotOk
        }
        
        let result = try JSONDecoder().decode(responseType.objectType, from: data)
        return result as! T
    }
}
