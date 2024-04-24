import Foundation

struct TopRatedMovie: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Movie: Codable, Identifiable {
        let id: Int
        let title: String
        let originalTitle: String
        let overview: String
        let posterPath: String?
        let backdropPath: String?
        let releaseDate: String
        let voteAverage: Double
        let voteCount: Int
        let popularity: Double
        let genreIds: [Int]
        let adult: Bool
        let video: Bool
        
        private enum CodingKeys: String, CodingKey {
            case id, title, overview, popularity, adult, video
            case originalTitle = "original_title"
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case genreIds = "genre_ids"
        }
    }
}
