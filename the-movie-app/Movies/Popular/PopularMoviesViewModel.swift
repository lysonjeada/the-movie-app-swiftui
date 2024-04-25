import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    private let useCase: MoviesUseCase
    @Published var popularMovies: [MovieInfo] = []
    @Published var topRatedMovies: [MovieInfo] = []
    @Published var upcomingMovies: [MovieInfo] = []
    
    init() {
        self.useCase = MoviesUseCase(apiService: ApiService())
    }
    
    func loadPopularMovies() {
        Task {
            do {
                let movies = try await useCase.getListOfPopularMovies()
                DispatchQueue.main.async {
                    self.popularMovies = movies
                }
            } catch {
                // Handle the error here, such as displaying an error message
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func loadTopRatedMovies() {
        Task {
            do {
                let movies = try await useCase.getListOfTopRatedMovies()
                DispatchQueue.main.async {
                    self.topRatedMovies = movies
                }
            } catch {
                // Handle the error here, such as displaying an error message
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func loadUpcomingMovies() {
        Task {
            do {
                let movies = try await useCase.getListOfUpcomingMovies()
                DispatchQueue.main.async {
                    self.upcomingMovies = movies
                }
            } catch {
                // Handle the error here, such as displaying an error message
                print("Error fetching movies: \(error)")
            }
        }
    }
}

