import SwiftUI

struct Country: Decodable, Identifiable {//make decodeable so swift can take JSON
    var id = UUID()
    let name: Name
    let region: String
    let population: Int
    let flags: Flag

    struct Flag: Decodable {
        let png: String
    }

    struct Name: Decodable {
        let common: String
    }
}

struct CountryFinderView: View {
    @State private var searchTerm = ""
    
    @State private var countries: [Country] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("4:58")
                Spacer()
                
                Image("topright")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)//copied from previous project
            }
            .padding(.horizontal)

            NavigationStack {
                Form {
                    Section("Search") {
                        TextField("Type country name", text: $searchTerm)//user input
                        Button {
                            Task {
                                countries = await fetchData(for: searchTerm)//when clicked, call fetchData and update countries
                            }
                        } label: {
                            Text("Search")
                                .padding(.vertical, 15)
                                .padding(.horizontal, 35)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                                
                        }
                    }

                    Section("Results") {
                        List(countries) { country in
                            CountryRowView(country: country)
                            
                        }
                    }
                }
                .navigationTitle("Country Lookup")
            }
            
        }
    }
    

    func fetchData(for name: String) async -> [Country] {// build URL using URLComponents, easier than string-concatenation
        var components = URLComponents(string: "https://restcountries.com/v3.1/name/\(name)")
        
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "name,region,population,flags")//query parameters allow me to only send back name, region, population, and flags
        ]

        guard let url = components?.url else {//i did this make sure URL is valid
            fatalError("Invalid URL")
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)//Get request, write _ for second parameter cus i don't use it
            
            let result = try JSONDecoder().decode([Country].self, from: data)//this is the thing that creates each [Country] struct, turns JSON into usable swift data
            return result
        } catch {
            print("Error: \(error)")
            return []
        }
        
    }
}

