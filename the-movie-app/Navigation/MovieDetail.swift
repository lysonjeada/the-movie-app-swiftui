import Foundation
import SwiftUI

enum MovieType {
    case popularMovies
    case favoriteMovies
}

struct MovieInfo: Identifiable, Hashable {
    var id = UUID()
    let movieId: Int
    let name: String
    let image: String
    let type: MovieType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct MovieDetail: View {
    @Environment(\.presentationMode) var presentationMode
    let type: MovieType
    
    init(type: MovieType = .popularMovies){
        UITabBar.appearance().backgroundColor = .white
        self.type = type
    }
    
    var body: some View {
        NavigationView {
            switch type {
            case .popularMovies:
                NavigationStack {
                    HomeView()
                }
            case .favoriteMovies:
                ListMovieFavoritesView()
            }
        }
        .navigationBarTitle("Movies", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // Oculta o botão de volta padrão
        .navigationBarItems(leading: customBackButton)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.leading)
        .edgesIgnoringSafeArea(.trailing)
        .background(.black)
        .background(ignoresSafeAreaEdges: .all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
    
    var customBackButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white) // Define a cor do ícone
                .imageScale(.large)
                .padding() // Adiciona um pouco de espaço ao redor do ícone
        }
    }
}

struct MovieDetailPreview: PreviewProvider {
    static var previews: some View {
        MovieDetail(type: .popularMovies)
    }
}
