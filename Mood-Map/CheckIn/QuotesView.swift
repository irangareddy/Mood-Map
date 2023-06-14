//
//  QuotesView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 15/06/23.
//

import SwiftUI

struct QuotesView: View {
    @ObservedObject var viewModel = QuotesViewModel()
    
    var body: some View {
        if let quote = viewModel.quoteForCurrentDay() {
            VStack(alignment: .leading,spacing: 10) {
                Text(quote.quote)
                    .font(.appHeadline)
                Text("- \(quote.author)")
                    .font(.appSubheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(quote.importance)
                    .font(.appSmallBody)
                    .foregroundColor(.gray)
            }.multilineTextAlignment(.center)
                .padding()
        } else {
            Text("No quote available for today.")
        }
    }
}


struct QuotesView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesView()
    }
}
