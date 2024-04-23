import SwiftUI
import URLImage

protocol PopularMoviesViewProtocol {
    
}

class PopularMovieData: ObservableObject, Identifiable {
    @Published var id: Int
    @Published var image: String
    @Published var name: String
    
    init(id: Int, image: String, name: String) {
        self.id = id
        self.image = image
        self.name = name
    }
}

struct PopularMoviesView: View, PopularMoviesViewProtocol {
    
    @StateObject private var viewModel = PopularMoviesViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.movies) { movie in
                HStack {
                    
                    Text("\(movie.name)")
                }
            }
        }
        .task {
            await viewModel.getListOfPopularMovies()
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Todos")
        
    }
}

#Preview {
    PopularMoviesView_Previews.previews
}

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        return PopularMoviesView()
    }
}
