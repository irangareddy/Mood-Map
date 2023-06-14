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
    @Published var isLoading: Bool = false

    func updateLoading(_ status: Bool) {
        DispatchQueue.main.async {
            self.isLoading = status
        }
    }

    func handleAppError(_ error: Error) {
        DispatchQueue.main.async {
            self.appError = AppError.customError(error.localizedDescription)
            self.updateLoading(false)
        }
    }
}

class AuthViewModel: BaseViewModel {
    static let shared = AuthViewModel()
    @Published var isUserLoggedIn: Bool = false
    @Published var error: NetworkError?
    @Published var currentUser: User<[String: AnyCodable]>?

    private var networkManager = NetworkManager.shared

    override init() {
        super.init()
        validateCurrentSession()
    }

    func validateCurrentSession() {
        Task {
            do {
                if let isUserLoggedIn = try await networkManager.getCurrentSession() {
                    if isUserLoggedIn {
                        await getCurrentUserDetails()
                    }
                    DispatchQueue.main.async {
                        self.isUserLoggedIn = isUserLoggedIn
                        self.isLoading = false
                    }
                }
            } catch {
                handleAppError(error)
            }
        }
    }

    func deleteSession(session: AppwriteSessions) async {
        Task {
            do {
                updateLoading(true)
                switch session {
                case .current:
                    _ = try await networkManager.account.deleteSession(sessionId: session.rawValue)
                case .all:
                    _ = try await networkManager.account.deleteSessions()
                }
                wipeSessionInfo()
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
                validateCurrentSession()
            } catch {

                handleAppError(error)
            }
        }
        updateLoading(false)
    }

    func signUp(name: String, email: String, password: String) async {
        Task {
            do {
                updateLoading(true)
                try await networkManager.createAccount(name: name, email: email, password: password)
                validateCurrentSession()
            } catch {
                handleAppError(error)
            }
        }
        updateLoading(false)
    }

    func login(email: String, password: String) async throws {
        Task {
            do {
                updateLoading(true)
                let result = try await networkManager.account.createEmailSession(email: email, password: password)
                await validateCurrentSession()
            } catch {
                handleAppError(error)
            }
        }
        updateLoading(false)
    }

    func logout() async {
        Task {
            do {
                await deleteSession(session: .current)
                wipeSessionInfo()
                DispatchQueue.main.async {
                    self.isUserLoggedIn = false
                }
            } catch {
                handleAppError(error)
            }
        }
    }

    func getCurrentUserDetails() async {
        do {
            let user = try await networkManager.getAccount()
            DispatchQueue.main.async {
                self.currentUser = user
            }
        } catch {
            // Handle any error that occurs during fetching user details
            handleAppError(error)
        }
    }

    func resetPassword(password: String) {
        Task {
            do {
                let user = try await networkManager.account.updatePassword(password: password)
            } catch {
                // Handle any error that occurs during resetting password
                handleAppError(error)
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
