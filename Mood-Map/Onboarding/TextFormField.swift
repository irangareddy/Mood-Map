//
//  TextFormField.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

struct TextFormField: View {
    @State var title: String = ""
    @State var placeholder: String = ""
    @Binding var textfieldContent: String

    @State var limit: Int!
    @State var keyboardType: UIKeyboardType?

    @State var isNameValidatorEnabled = false
    @State var isEmailValidatorEnabled = false
    @State var validatedText: String = ""

    @State var dynamicWidth = false
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.gray)
            TextField(placeholder, text: isNameValidatorEnabled ? nameEnabledText() : text())
                .keyboardType(keyboardType ?? .default)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentColor, lineWidth: 3)
                )
        }.font(.appBody)
        .frame(width: dynamicWidth ? nil : UIScreen.main.bounds.width * 0.8,
               height: 64)

    }

    func text() -> Binding<String> {
        guard let limit = limit else {
            return $textfieldContent
        }
        return $textfieldContent.max(limit)
    }

    func nameEnabledText() -> Binding<String> {
        return Binding {
            validatedText.trimmingCharacters(in: CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters).inverted)
        } set: { newValue, _ in
            validatedText = newValue.trimmingCharacters(in: CharacterSet.uppercaseLetters.union(CharacterSet.lowercaseLetters).inverted)
            textfieldContent = validatedText
        }
    }
}

struct TextFormField_Previews: PreviewProvider {
    static var previews: some View {
        TextFormField(title: "Name", placeholder: "Place goes here", textfieldContent: .constant("Kanishka"))
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
