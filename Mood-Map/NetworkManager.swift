//
//  NetworkManager.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 18/05/23.
//

import Foundation
import Appwrite
import AppwriteModels
import Combine
import JSONCodable
import NIO
import MoodMapKit

func wipeSessionInfo() {
    UserDefaults.standard.removeObject(forKey: .userId)
    UserDefaults.standard.removeObject(forKey: .sessionId)
    UserDefaults.standard.synchronize()
}

enum AppwriteSessions: String {
    case all
    case current
}

enum UserDefaultsError: Error {
    case userIdNotFound
}

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case urlError
    case dataConversionError
    case fileNotUploadedError
}

class NetworkManager {
    static let shared = NetworkManager()
    let client: Client
    let account: Account
    let databases: Databases
    let functions: Functions
    let storage: Storage

    private init() {
        self.client = Client()
            .setEndpoint(K.END_POINT)
            .setProject(K.PROJECT_ID)
            .setSelfSigned()
        self.account = Account(client)
        self.databases = Databases(client)
        self.functions = Functions(client)
        self.storage = Storage(client)

        Task { try! await listSessions() }    }

    // MARK: - Authentication

    // MARK: Create Account

    func createAccount(email: String = "", password: String = "") async throws {
        do {
            let user = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password,
                name: "Ranga"
            ) as AppwriteModels.User

            // Save the user object in UserDefaults
            UserDefaults.standard.set(user.id, for: .userId)

            try await getAccount()
        } catch {
            debugPrint("ERROR: On Create Account \(dump(error))")
        }
    }

    // MARK: Get Account

    func getAccount() async throws -> User<[String: AnyCodable]> {
        do {
            let user = try await account.get() as User<[String: AnyCodable]>
            return user
        } catch {
            debugPrint("ERROR: On Get Account \(dump(error))")
            throw error
        }
    }

    // MARK: List Sessions

    func listSessions() async throws {
        do {
            let sessions = try await account.listSessions()
            if sessions.total > 1 {
                _ = try! await getAccount()
            }
        } catch {
            debugPrint("ERROR: On Get Account \(dump(error))")
        }
    }

    func getSessionInfo() -> (sessionId: String, userId: String)? {
        guard let sessionId = UserDefaults.standard.string(for: .sessionId) else {
            // Handle the case when session ID is not found in UserDefaults
            return nil
        }

        guard let userId = UserDefaults.standard.string(for: .userId) else {
            // Handle the case when user ID is not found in UserDefaults
            return nil
        }

        return (sessionId, userId)
    }

    // MARK: Get Current Session

    func getCurrentSession() async throws -> Bool? {
        do {

            let session = try await account.getSession(sessionId: "current") as AppwriteModels.Session

            if let (sessionId, userId) = getSessionInfo() {
                // Use sessionId and userId variables here
                print("Session ID: \(sessionId)")
                print("User ID: \(userId)")

                if sessionId != session.id || userId != session.userId {
                    // Wipe session information if sessionId and userId do not match the condition
                    wipeSessionInfo()
                }
            } else {
                UserDefaults.standard.set(session.userId, for: .userId)
                UserDefaults.standard.set(session.id, for: .sessionId)
                print("Create a new Session")
            }

            return true
        } catch {
            debugPrint("ERROR: Get Current Session \(dump(error))")
            return false
            throw error

        }
    }

    // MARK: - Document Generics

    // MARK: CREATE

    func createDocument<T: Codable>(collectionId: String, data: T, permissions: [String]) async throws {

        guard let userId = UserDefaults.standard.string(for: .userId) else {
            // Handle the case when user ID is not found in UserDefaults
            throw UserDefaultsError.userIdNotFound
        }
        
        debugPrint(dump(data))

        do {
            _ = try await databases.createDocument(
                databaseId: K.DATABASE_ID,
                collectionId: collectionId,
                documentId: ID.unique(),
                data: data,
                permissions: [
                    Permission.read(Role.user(userId)),
                    Permission.write(Role.user(userId)),
                    Permission.delete(Role.user(userId)),
                    Permission.update(Role.user(userId))
                ]
            )

//            let payload = ["userId": userId, "from": "mobile"]
//            if let jsonPayload = convertToJsonString(payload: payload) {
//                debugPrint("Sending payload \(jsonPayload)")
//                await self.executeCloudFuction(of: K.HEATMAP_FUNCTION_ID, payload: jsonPayload)
//            }
        }
    }

    // MARK: READ

    func readDocuments<T: Codable>(collectionId: String) async throws -> [AppwriteModels.Document<T>] {
        do {
            let document = try await databases.listDocuments(
                databaseId: K.DATABASE_ID,
                collectionId: collectionId,
                nestedType: T.self
            )

            return document.documents
        } catch {
            _ = error.localizedDescription
            // Return an error response or handle the error as appropriate for your use case
            throw error
        }
    }

    // MARK: UPDATE

    // MARK: DELETE

    func deleteDocument(collectionId: String, documentId: String) async throws {
        do {
            _ = try await databases.deleteDocument(
                databaseId: K.DATABASE_ID,
                collectionId: collectionId,
                documentId: documentId
            )
        } catch {
            print("error from here \(dump(error))")
        }
    }

    // MARK: - Cloud Functions Executions

    func executeCloudFuction(of id: String, payload: String) async {
        do {
            let execution = try await functions.createExecution(
                functionId: id,
                data: payload,
                async: false
            )
            dump(execution)
        } catch {
            print("error from cloud function \(id) \(dump(error))")
        }

    }

    // MARK: - STORAGE

    func saveImageInStorage(_ fileData: Data, fileName: String, mime: String) async throws -> File {
        let file = InputFile.fromData(
            fileData,
            filename: fileName,
            mimeType: mime
        )

        do {
            let file = try await storage.createFile(
                bucketId: K.IMAGES_BUCKET_ID,
                fileId: ID.unique(),
                file: file,
                onProgress: { progress in
                    print("Upload Progress: \(progress) / \(progress)")
                }
            )
            print("Image stored successfully!")
            print("File ID: \(file.id)")
            print("File URL: \(file.mimeType)")
            print("File Details: \(dump(file))")
            return file
        } catch {
            print("Error while uploading file: \(error)")
            throw error
        }
    }

    func saveAudio(_ fileData: Data) async {
        let id = ID.unique()
        let file = InputFile.fromData(
            fileData,
            filename: "\(id)-masakali.wav",
            mimeType: "audio/x-wav"
        )

        do {
            let file = try await storage.createFile(
                bucketId: "647751475c51d1e48b5d",
                fileId: id,
                file: file,
                onProgress: { progress in
                    print("Upload Progress: \(progress) / \(progress)")
                }
            )
            print("Image stored successfully!")
            print("File ID: \(file.id)")
            print("File URL: \(file.mimeType)")
            print("File Details: \(dump(file))")
        } catch {
            print("Error while uploading file: \(error)")
        }
    }

    func listFile() async throws {
        do {
            let response = try await storage.listFiles(bucketId: "647751475c51d1e48b5d")
            dump(response)
        } catch {
            print("Listing files in bucket")
        }

    }

    func preview(fileId: String) async throws -> ByteBuffer? {
        try await listFile()
        do {
            let response = try await storage.getFilePreview(
                bucketId: "647751475c51d1e48b5d",
                fileId: fileId
            )
            return response

        } catch {
            print("On networking \(fileId)")
        }
        return nil
    }

    func previewAudio(fileId: String) async throws -> ByteBuffer? {
        try await listFile()
        do {
            let response = try await storage.getFileView(
                bucketId: "647751475c51d1e48b5d",
                fileId: fileId
            )
            return response

        } catch {
            print("On networking \(fileId) \(error)")
        }
        return nil
    }

}

func getImageDataFromByteBuffer(_ buffer: ByteBuffer) -> Data? {
    var data = Data()
    var buffer = buffer

    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
        data.append(contentsOf: bytes)
        return data
    }

    return nil
}

// TODO: AUTH CREATE ACCOUNT
// TODO: SAVE IN LOCAL PREFERENCE
// TODO:

func convertToJsonString(payload: Any) -> String? {
    do {
        let jsonData: Data
        if let payloadData = payload as? Data {
            jsonData = payloadData
        } else {
            jsonData = try JSONSerialization.data(withJSONObject: payload)
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        print("Error serializing payload: \(error)")
        return nil
    }
}
