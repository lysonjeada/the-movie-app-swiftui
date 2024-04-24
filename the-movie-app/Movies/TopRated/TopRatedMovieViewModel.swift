import Foundation

class TopRatedMovieViewModel: ObservableObject {
    private let useCase = TopRatedMoviesUseCase()
    @Published var moviesData: [PopularMoviesData] = []
    
    func loadData() {
        Task {
            do {
                let movies = try await useCase.getListOfPopularMovies()
                DispatchQueue.main.async { [weak self] in
                    movies.forEach { movie in
                        let popularMovie = PopularMoviesData(id: movie.id, image: movie.posterPath ?? "", name: movie.title)
                        self?.moviesData.append(popularMovie)
                    }
                }
            } catch {
                print("Error fetching top rated movies: \(error)")
            }
        }
    }
}
