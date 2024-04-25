import SwiftUI
import URLImage

enum MovieCategory {
    case popular, topRated, upcoming
    
    var title: String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel = MoviesViewModel()
    @StateObject var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach([MovieCategory.popular, MovieCategory.topRated, MovieCategory.upcoming], id: \.self) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(self.movies(for: category)) { movie in
                                    MovieCard(movie: movie, favoritesViewModel: favoritesViewModel)
                                        .frame(width: 160, height: 350) // Definir altura e largura fixas para a MovieCard
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                    }
                    .padding(.horizontal, 0)
                }
            }
        }
        .padding(.top, 40)
        .onAppear {
            viewModel.loadPopularMovies()
            viewModel.loadTopRatedMovies()
            viewModel.loadUpcomingMovies()
        }
        .background(Color.black.opacity(0.93).edgesIgnoringSafeArea(.all))
    }
    
    private func movies(for category: MovieCategory) -> [MovieInfo] {
        switch category {
        case .popular:
            return viewModel.popularMovies
        case .topRated:
            return viewModel.topRatedMovies
        case .upcoming:
            return viewModel.upcomingMovies
        }
    }
}

struct MovieCard: View {
    @State private var isFavorited = false
    let movie: MovieInfo
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.image)") {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 250)
                            .clipped()
                            .cornerRadius(8)
                            .padding(.top, 4)
                    }
                    .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 250)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .padding(10)
                }
                .padding(.bottom, 10)
                .padding(.trailing, 10)
            }
            Text(movie.name)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.bottom)
        }
        
        .padding(.horizontal)
        .clipped()
        .onTapGesture {
            addFavorite(movieId: movie.movieId)
            isFavorited.toggle()
        }
        .onAppear {
            isFavorited = favoritesViewModel.isFavorite(movieId: movie.movieId)
        }
    }
    
    func addFavorite(movieId: Int) {
        favoritesViewModel.addToFavorites(movieId: movieId)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

