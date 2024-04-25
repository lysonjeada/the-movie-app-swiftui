import SwiftUI
import CoreData

class AppState: ObservableObject {
    @Published var hasAuthenticated: Bool
    
    init(hasAuthenticated: Bool) {
        self.hasAuthenticated = hasAuthenticated
    }
}

@main
struct DemoApp: App {
    @StateObject var appState = AppState(hasAuthenticated: false)
    let movies = [MovieInfo(name: "Popular", image: "film", type: .popularMovies), .init(name: "Favorites", image: "film", type: .favoriteMovies)]
    
    var body: some Scene {
        WindowGroup {
            if appState.hasAuthenticated {
                NavigationMovies(movies: movies)
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}

struct ContentView: View {
    @State private var authenticationState: AuthenticationState = .loading
    @EnvironmentObject var appState: AppState
    private var authenticator: Authenticator
    
    init(authenticator: Authenticator = Authenticator()) {
        self.authenticator = authenticator
    }
    
    var body: some View {
        
        NavigationStack {
            VStack {
                switch authenticationState {
                case .loading:
                    ProgressView("Loading...")
                case .success:
                    Text("Authentication successful!")
                        .foregroundColor(.white)
                    Button {
                        appState.hasAuthenticated = true
                    } label: {
                        Text("See movies")
                            .padding()
                            .foregroundStyle(.white)
                            .font(.title)
                            .frame(width: 300)
                            
                    }
                case .failure:
                    Text("Authentication failed!")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(
                Image("haunting-of-hill-house")
                
            )
        }
        
        .onAppear {
            authenticator.authenticate { success in
                if success {
                    authenticationState = .success
                } else {
                    authenticationState = .failure
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .black // Define a cor de fundo da barra de navegação como preto
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Define a cor do título da barra de navegação como branco
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Define a cor do título grande da barra de navegação como branco
        
        navigationBar.standardAppearance = coloredAppearance
        navigationBar.scrollEdgeAppearance = coloredAppearance
    }
}
