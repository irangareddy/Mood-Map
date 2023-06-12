//
//  AuthViewModel.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 08/06/23.
//

import Foundation
import AppwriteModels
import JSONCodable
import MoodMapKit

class BaseViewModel: ObservableObject {
    @Published var appError: AppError?

    func handleAppError(_ error: Error) {
        DispatchQueue.main.async {
            self.appError = AppError.customError(error.localizedDescription)
        }
    }
}

class AuthViewModel: BaseViewModel {
    static let shared = AuthViewModel()
    @Published var isUserLoggedIn: Bool = false
    @Published var isLoading = false
    @Published var error: NetworkError?
    @Published var currentUser: User<[String: AnyCodable]>?

    private var networkManager = NetworkManager.shared

    func validateCurrentSession() {
        Task {
            do {
                if let isUserLoggedIn = try await networkManager.getCurrentSession() {
                    DispatchQueue.main.async { [self] in
                        if isUserLoggedIn {
                            self.getCurrentUserDetails()
                        }
                        self.isUserLoggedIn = isUserLoggedIn
                    }
                }

            } catch {
                handleAppError(error)
            }
        }
    }

    func deleteSession(session: AppwriteSessions) {
        Task {
            do {
                let sessions: Any // Define the sessions variable with appropriate type
                switch session {
                case .current:
                    sessions = try await networkManager.account.deleteSession(sessionId: session.rawValue)
                case .all:
                    sessions = try await networkManager.account.deleteSessions()
                }
                wipeSessionInfo()
                debugPrint("Deleted Session Info")
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
            } catch {
                handleAppError(error)
            }
        }
    }

    func signUp(name: String, email: String, password: String) {
        Task {
            do {
                try await networkManager.createAccount(name: name, email: email, password: password)
                self.validateCurrentSession()
            } catch {
                debugPrint("On Sign Up")
            }
        }

    }

    func login(email: String, password: String) throws {
        Task {
            do {
                let result = try await networkManager.account.createEmailSession(email: email, password: password)
                self.validateCurrentSession()
            } catch {
                handleAppError(error)
            }
        }

    }

    // About Current User
    func getCurrentUserDetails() {
        Task {
            do {
                let user = try await networkManager.getAccount()
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } catch {
                // Handle any error that occurs during fetching user details
                print("Error fetching user details: \(error)")
            }
        }
    }

    func resetPassword(password: String) {
        Task {
            do {
                let user = try await networkManager.account.updatePassword(password: password, oldPassword: nil)
                print("on forgot password \(user)")
            } catch {
                // Handle any error that occurs during fetching user details
                print("Error fetching user details: \(error)")
            }
        }
    }

}

enum AppError: LocalizedError {
    case missingName
    case invalidEmail
    case networkError
    case serverError(statusCode: Int)
    case parsingError
    case authenticationError
    case expiredSession
    case customError(String)

    var errorDescription: String? {
        switch self {
        case .missingName:
            return "Name is a required field."
        case .invalidEmail:
            return "Invalid email address."
        case .networkError:
            return "A network error occurred."
        case .serverError(let statusCode):
            return "A server error occurred. Status code: \(statusCode)"
        case .parsingError:
            return "An error occurred while parsing data."
        case .authenticationError:
            return "Authentication failed."
        case .expiredSession:
            return "Session has expired."
        case .customError(let message):
            return message
        }
    }
}
