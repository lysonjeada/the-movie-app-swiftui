import SwiftUI

struct NavigationMovies: View {
    @State private var selectedMovie: MovieInfo?
    private var movies: [MovieInfo]
    
    init(movies: [MovieInfo]) {
        self.movies = movies
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("us-background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    List(movies) { movie in
                        NavigationLink(destination: MovieDetail(type: movie.type)) {
                            ContentCell(name: movie.name)
                        }
                        .listRowBackground(Color.black.opacity(0.1))
                        .padding(.horizontal)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black.opacity(0.2))
                    .foregroundColor(.white)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.leading)
            .edgesIgnoringSafeArea(.trailing)
            .background(.black)
            .background(ignoresSafeAreaEdges: .all)
            .navigationTitle("Movies")
        }
    }
}

struct ContentCell: View {
    let name: String
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text(name)
                    .foregroundColor(.white)
                    .padding()
                
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity) // Ocupa toda a largura disponível
            }
            .frame(width: (geometry.size.width), height: geometry.size.height, alignment: .center)
            .background(Color.black.opacity(0.3))// Working
        }
    }
}

struct NavigationMoviesPreview: PreviewProvider {
    static var previews: some View {
        NavigationMovies(movies: [
            .init(name: "Popular", image: "film", type: .popularMovies),
            .init(name: "Favorites", image: "film", type: .favoriteMovies)
        ])
    }
}

struct CustomNavigationStyle: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content.navigationViewStyle(StackNavigationViewStyle())
    }
}
