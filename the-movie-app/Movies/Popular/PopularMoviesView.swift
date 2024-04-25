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
                                    MovieCard(movie: movie)
                                        .frame(width: 160)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .background(Color.black.opacity(1.0))
                            .cornerRadius(12)
                        }
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            viewModel.loadPopularMovies()
            viewModel.loadTopRatedMovies()
            viewModel.loadUpcomingMovies()
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)) // Fundo escuro para a tela inteira
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
    let viewModel = FavoritesViewModel()
    
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
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 250)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Toggle favorite state
                    addFavorite(movieId: movie.id.toInt())
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
                .font(.caption)
                .foregroundColor(.white) // Texto do filme em branco
                .lineLimit(2)
                .padding(.horizontal)
        }
    }
    
    func addFavorite(movieId: Int) {
        viewModel.addToFavorites(movieId: movieId)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension Int {
    func toUUID() -> UUID {
        var bytes: [UInt8] = []
        var mutableSelf = self
        for _ in 0..<MemoryLayout.size(ofValue: self) {
            bytes.append(UInt8(truncatingIfNeeded: mutableSelf))
            mutableSelf >>= 8
        }
        return UUID(uuid: (bytes[0], bytes[1], bytes[2], bytes[3],
                           bytes[4], bytes[5], bytes[6], bytes[7],
                           bytes[8], bytes[9], bytes[10], bytes[11],
                           bytes[12], bytes[13], bytes[14], bytes[15]))
    }
}

extension UUID {
    func toInt() -> Int {
        let uuidString = self.uuidString.replacingOccurrences(of: "-", with: "")
        guard let intVal = Int(uuidString, radix: 16) else {
            fatalError("Failed to convert UUID to Int")
        }
        return intVal
    }
}
