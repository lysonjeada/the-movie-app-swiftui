import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteMovie] = []
    private let accountId = 10991131
    private let useCase = AddFavoriteMovieUseCase()
    private let listUseCase = ListFavoritesUseCase()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func addToFavorites(movieId: Int) {
        useCase.addToFavorites(accountId: Int32(accountId), movieId: movieId) { [weak self] result in
            switch result {
            case .success(let response):
                print("Added to favorites successfully:")
                print(response)
                // Refresh the favorites list
                self?.fetchFavorites()
            case .failure(let error):
                print("Error adding to favorites:")
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFavorites() {
        listUseCase.fetchFavoriteMovies(accountId: Int32(accountId)) { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.favorites = movies
                }
            case .failure(let error):
                print("Error fetching favorites:")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func isFavorite(movieId: Int) -> Bool {
            return favorites.contains { $0.id == movieId }
        }
}

struct Movie: Identifiable {
    let id: Int
    let title: String
    let posterPath: String
}


