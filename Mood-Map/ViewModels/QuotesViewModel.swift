//
//  QuotesViewModel.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 15/06/23.
//

import Foundation
import SwiftUI

struct Quote: Codable, Equatable {
    let quote: String
    let author: String
    let importance: String
}

class QuotesViewModel: ObservableObject {
    @Published var quotes: [Quote] = []

    init() {
        loadQuotes()
    }

    func loadQuotes() {
        if let quotesFileURL = Bundle.main.url(forResource: "quotes", withExtension: "json") {
            do {
                let quotesData = try Data(contentsOf: quotesFileURL)
                let decoder = JSONDecoder()
                self.quotes = try decoder.decode([Quote].self, from: quotesData)
            } catch {
                print("Error loading quotes: \(error.localizedDescription)")
            }
        }
    }

    func quoteForCurrentDay() -> Quote? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())

        return quotes.first { quote in
            let quoteIndex = quotes.firstIndex(of: quote) ?? 0
            return quoteIndex == (weekday - 1)
        }
    }
}
