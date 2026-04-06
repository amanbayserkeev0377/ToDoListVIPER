import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL"
        case .noData: return "Нет данных"
        case .decodingError: return "Ошибка обработки данных"
        case .serverError(let code): return "Ошибка сервера \(code)"
        }
    }
}

// MARK: - NetworkService
final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private enum API {
        static let baseURL = "https://dummyjson.com"
        static let todosPath = "/todos"
    }
    
    private let session = URLSession.shared
    
    func fetchTodos(completion: @escaping (Result<[ToDoTask], Error>) -> Void) {
        guard let url = URL(string: API.baseURL + API.todosPath) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodoResponseDTO.self, from: data)
                let tasks = response.todos.map { $0.toDomain() }
                completion(.success(tasks))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
