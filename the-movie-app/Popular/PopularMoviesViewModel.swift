import Foundation

class PopularMoviesViewModel: ObservableObject {
    private let useCase = PopularMoviesUseCase()
    @Published var popularMoviesData: [PopularMoviesData] = []
    
    func loadData() {
        Task {
            do {
                let movies = try await useCase.getListOfPopularMovies()
                DispatchQueue.main.async { [weak self] in
                    movies.forEach { movie in
                        let popularMovie = PopularMoviesData(id: movie.id, image: movie.posterPath ?? "", name: movie.title)
                        self?.popularMoviesData.append(popularMovie)
                    }
                }
            } catch {
                // Handle the error here, such as displaying an error message
                print("Error fetching popular movies: \(error)")
            }
        }
    }
}
