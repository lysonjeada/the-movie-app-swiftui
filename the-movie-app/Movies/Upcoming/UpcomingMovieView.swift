import SwiftUI
import URLImage

struct UpcomingMovieView: View {
    
    @ObservedObject var viewModel = UpcomingMovieViewModel()
    
    @State private var moviesData: [PopularMoviesData] = []
    
    let columns = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        VStack {
            if viewModel.moviesData.isEmpty {
                Text("empty state")
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(viewModel.moviesData, id: \.id) { movie in
                            MoviesView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    UpcomingMovieView_Previews.previews
}

struct UpcomingMovieView_Previews: PreviewProvider {
    static var previews: some View {
        return UpcomingMovieView()
    }
}
