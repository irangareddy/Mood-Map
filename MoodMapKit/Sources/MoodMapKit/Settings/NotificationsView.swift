//
//  NotificationsView.swift
//  MoodMapKit
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI
import UserNotifications

// MARK: NotificationsScreen

/// A view that manages the notifications settings and reminders.
///
/// The `NotificationsScreen` view allows the user to enable or disable notifications, manage reminders, and schedule notifications.
public struct NotificationsScreen: View {
    /// A boolean value indicating whether notifications are enabled.
    @AppStorage("isNotificationEnabled") public var isNotificationEnabled: Bool = false

    /// The data representing the reminders.
    @AppStorage("reminders") public var remindersData: Data = Data()

    /// The reminders displayed in the view.
    @State public var reminders: [Reminder]

    /// A boolean value indicating whether to show the add reminder sheet.
    @State private var showAddReminderSheet = false

    public var body: some View {
        VStack {
            List {
                Section {
                    Toggle("Daily Reminders", isOn: $isNotificationEnabled)
                        .font(.appSubheadline)
                        .padding()
                        .onChange(of: isNotificationEnabled) { _ in
                            updateNotificationAuthorization()
                        }
                } footer: {
                    Text("Unlock deeper insights into your emotional being through the power of consistent self-reflection.")
                        .font(.appCaption)
                }
                Section {
                    ForEach(reminders) { reminder in
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(reminder.timeOfDay.rawValue)
                                    .font(.appHeadline)
                                Text("\(reminder.time.displayString)")
                                    .font(.appSubheadline)
                            }

                            Spacer()
                            Image(systemName: "pencil")
                                .font(.headline)
                                .onTapGesture {
                                    editReminder(reminder)
                                }
                        }
                    }
                    .onDelete(perform: deleteReminder)
                }
            }
            .listStyle(.automatic)
            .padding(.top)

            Button(action: {
                showAddReminderSheet = true
            }) {
                Text("Add Reminder")
                    .font(.appSubheadline)
            }
            .padding()
        }
        .navigationTitle("Notifications")
        .onAppear {
            loadReminders()
        }
        .sheet(isPresented: $showAddReminderSheet, content: {
            AddReminderView(reminders: $reminders)
                .onDisappear {
                    saveReminders()
                }
                .presentationDetents([.medium, .large])
        })
    }

    /// Updates the notification authorization based on the `isNotificationEnabled` value.
    func updateNotificationAuthorization() {
        if isNotificationEnabled {
            requestNotificationAuthorization()
        } else {
            removeNotificationAuthorization()
        }
    }

    /// Requests authorization for notifications.
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                isNotificationEnabled = granted
            }
        }
    }

    /// Removes the notification authorization and cancels all pending and delivered notifications.
    func removeNotificationAuthorization() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    /// Deletes the specified reminder at the given offsets.
    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        saveReminders()
    }

    /// Saves the reminders data and schedules the notifications.
    func saveReminders() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(reminders) {
            remindersData = encodedData
        }

        scheduleNotifications()
    }

    /// Loads the reminders from the data.
    func loadReminders() {
        let decoder = JSONDecoder()
        if let decodedReminders = try? decoder.decode([Reminder].self, from: remindersData) {
            reminders = decodedReminders
        }
    }

    /// Schedules the notifications based on the reminders data.
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        for reminder in reminders {
            guard isNotificationEnabled else {
                continue // Skip sending notifications when isNotificationEnabled is false
            }

            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "This is a reminder"
            content.sound = UNNotificationSound.default

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            guard let date = formatter.date(from: reminder.timeString) else {
                continue
            }

            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    /// Returns the color associated with the given time of day.
    ///
    /// - Parameter timeOfDay: The time of day.
    /// - Returns: The color associated with the time of day.
    func timeOfDayColor(_ timeOfDay: TimeOfDay) -> Color {
        switch timeOfDay {
        case .morning:
            return .green
        case .afternoon:
            return .blue
        case .evening:
            return .orange
        case .night:
            return .purple
        }
    }

    /// Edits the specified reminder.
    ///
    /// - Parameter reminder: The reminder to edit.
    func editReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isEditing = true
            showAddReminderSheet = true
        }
    }
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderReminders = [
            Reminder(timeString: "09:00"),
            Reminder(timeString: "12:30"),
            Reminder(timeString: "18:00")
        ]

        Group {
            // Light Mode Preview
            NotificationsScreen(reminders: placeholderReminders)
                .preferredColorScheme(.light)

            // Dark Mode Preview
            NotificationsScreen(reminders: placeholderReminders)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: TIME PICKER

/// A view for picking a time.
///
/// Use the `TimePicker` view to allow the user to select a time from a date picker.
public struct TimePicker: View {
    /// The selected time.
    @Binding public var selectedTime: Date

    /// Creates a new `TimePicker` view with the specified selected time.
    ///
    /// - Parameter selectedTime: The binding to the selected time.
    public init(selectedTime: Binding<Date>) {
        self._selectedTime = selectedTime
    }

    public var body: some View {
        VStack {
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.automatic)
                .labelsHidden()
        }
    }
}

// MARK: TIME

/// A struct representing a specific time.
///
/// Use the `Time` struct to store and work with time values.
public struct Time {
    /// The date representing the time.
    public let date: Date

    /// Initializes a `Time` instance with the given date.
    ///
    /// - Parameter date: The date representing the time. Defaults to the current date and time if not specified.
    public init(date: Date = Date()) {
        self.date = date
    }

    /// A formatted string representation of the time in "HH:mm" format.
    public var displayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
