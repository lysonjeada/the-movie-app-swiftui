import Foundation
import Combine

class ListMoviesFavoritesViewModel: ObservableObject {
    @Published var favorites: [PopularMoviesData] = []
    private let accountId = 10991131
    private let listUseCase = ListFavoritesUseCase()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchFavorites() {
        listUseCase.fetchFavoriteMovies(accountId: Int32(accountId)) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    movies.forEach { movie in
                        let movieData = PopularMoviesData(id: movie.id, image: movie.posterPath ?? "", name: movie.title)
                        self?.favorites.append(movieData)
                    }
                }
            case .failure(let error):
                print("Error fetching favorites:")
                print(error.localizedDescription)
            }
        }
    }
}
