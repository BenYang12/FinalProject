import SwiftUI

struct CountryRowView: View {
    let country: Country

    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: country.flags.png)) { image in
                image
                    .resizable()
                    .scaledToFit()

                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()//spinny thing
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(country.name.common)
                    .font(.headline)
                
                Text("Region: \(country.region)")
                    .font(.subheadline)
                
                Text("Population: \(country.population)")
                    .font(.subheadline)
                
            }
        }
        .padding(.vertical, 4)
    }
    
}
