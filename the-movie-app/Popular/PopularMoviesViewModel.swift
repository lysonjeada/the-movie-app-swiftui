import Foundation

@MainActor
class PopularMoviesViewModel: ObservableObject {
    
    @Published var movies: [PopularMovieData] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func getListOfPopularMovies() async {
        guard let data = try? await PopularMoviesService().getListOfPopularMovies() else {
            self.hasError = true
            return
        }
        
        data.forEach { movie in
            let movieData = PopularMovieData(id: movie.id, image: movie.posterPath ?? "", name: movie.title)
            movies.append(movieData)
        }
    }
}
