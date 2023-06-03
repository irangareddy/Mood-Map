//
//  AddReminderView.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// A view for adding or editing reminders.
///
/// Use the `AddReminderView` to allow users to add or edit reminders with a selected time.
public struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var reminders: [Reminder]
    @State private var selectedTime: Date = Date()

    /// The body of the view.
    public var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Text("Select Time")
                .font(.appTitle3)

            TimePicker(selectedTime: $selectedTime)
                .font(.appBody)

            Spacer()

            Button(action: {
                saveReminder()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 100).frame(width: 300).foregroundColor(.accentColor))
            }

            Spacer()
        }
        .padding(.vertical)
        .onAppear {
            // If editing an existing reminder, set the selected time
            if let editingReminder = reminders.first(where: { $0.isEditing }) {
                selectedTime = editingReminder.time.date
            }
        }
    }

    /// Saves the reminder with the selected time.
    func saveReminder() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: selectedTime)

        if let editingIndex = reminders.firstIndex(where: { $0.isEditing }) {
            reminders[editingIndex].timeString = timeString
            reminders[editingIndex].isEditing = false
        } else {
            let newReminder = Reminder(timeString: timeString)
            reminders.append(newReminder)
        }

        presentationMode.wrappedValue.dismiss()
    }
}
