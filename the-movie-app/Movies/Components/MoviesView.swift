import URLImage
import SwiftUI

struct MoviesView: View {
    @State private var isFavorited = false
    let movie: PopularMoviesData
    let viewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.image)") {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 300)
                            .clipped()
                            .cornerRadius(8)
                            .padding(.top, 4)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipped()
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Toggle favorite state
                    addFavorite(movieId: movie.id)
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
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.top, 4)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func addFavorite(movieId: Int) {
        viewModel.addToFavorites(movieId: movieId)
    }
}
