import Foundation

struct MovieData: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var posterPath: String
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    var voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

class MoviesUseCase {
    private let apiService: ApiService
    private let category: MovieCategory = .popular
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func getListOfPopularMovies() async throws -> [MovieInfo] {
        let popularMoviesData: PopularMovie = try await apiService.request(endpoint: .popularMovies, responseType: .popularMovies)
        
        var allMovies: [MovieInfo] = []
        
        allMovies.append(contentsOf: popularMoviesData.results.map {
            $0.toMovieInfo()
        })
        
        return allMovies
    }
    
    func getListOfTopRatedMovies() async throws -> [MovieInfo] {
        let topRatedMoviesData: TopRatedMovie = try await apiService.request(endpoint: .topRatedMovies, responseType: .topRatedMovies)
        
        var allMovies: [MovieInfo] = []
        
        allMovies.append(contentsOf: topRatedMoviesData.results.map {
            $0.toMovieInfo()
        })
        
        return allMovies

    }
    
    func getListOfUpcomingMovies() async throws -> [MovieInfo] {
        let upcomingMoviesData: UpcomingMovie = try await apiService.request(endpoint: .upcomingMovies, responseType: .upcomingMovies)
        
        var allMovies: [MovieInfo] = []
        
        allMovies.append(contentsOf: upcomingMoviesData.results.map {
            $0.toMovieInfo()
        })
        
        return allMovies
    }
    
    
//    func getListOfMovies() async throws -> [MovieInfo] {
//        let endpoint: Endpoint
//        let responseType: ResponseType
//        switch category {
//        case .popular:
//            endpoint = .popularMovies
//            responseType = .popularMovies
//        case .topRated:
//            endpoint = .topRatedMovies
//            responseType = .topRatedMovies
//        case .upcoming:
//            endpoint = .upcomingMovies
//            responseType = .upcomingMovies
//        }
//        
//        let movieDatas: [MovieData] = try await apiService.request(endpoint: endpoint, responseType: responseType)
//        let movies: [MovieInfo] = movieDatas.map { movieData in
//            // Aqui você pode fazer qualquer transformação necessária para criar MovieInfo a partir de MovieData
//            return MovieInfo(name: movieData.title, image: movieData.posterPath ?? "", type: .popularMovies)
//        }
//        
//        return movies
//    }
}

extension PopularMovie.Movie {
    func toMovieInfo() -> MovieInfo {
        return MovieInfo(
            movieId: self.id,
            name: self.title,
            image: self.posterPath ?? "",
            type: .popularMovies
        )
    }
}

extension TopRatedMovie.Movie {
    func toMovieInfo() -> MovieInfo {
        return MovieInfo(
            movieId: self.id,
            name: self.title,
            image: self.posterPath ?? "",
            type: .popularMovies
        )
    }
}

extension UpcomingMovie.Movie {
    func toMovieInfo() -> MovieInfo {
        return MovieInfo(
            movieId: self.id,
            name: self.title,
            image: self.posterPath ?? "",
            type: .popularMovies
        )
    }
}
