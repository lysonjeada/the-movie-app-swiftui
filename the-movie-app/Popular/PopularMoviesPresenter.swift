import Foundation

protocol PopularMoviesPresenterProtocol {
    func setListOfMovies(with movies: [PopularMovie.Movie])
}

class PopularMoviesPresenter: PopularMoviesPresenterProtocol {
    
    private var view: PopularMoviesViewProtocol?
    var popularMoviesData: [PopularMoviesData] = []
    
    init(view: PopularMoviesViewProtocol?) {
        self.view = view
    }
    
    func setListOfMovies(with movies: [PopularMovie.Movie]) {
        movies.forEach { movie in
            let movieData = PopularMoviesData(id: movie.id, image: movie.posterPath ?? "", name: movie.title)
            popularMoviesData.append(movieData)
        }
        
        view?.setMoviesData(with: popularMoviesData)
    }
}
