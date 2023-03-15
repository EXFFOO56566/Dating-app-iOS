
import Foundation
class GiftModel:BaseModel{
    struct GiftSuccessModel: Codable {
        let data: [Datum]?
        let code: Int?
        let message: String?
    }
    
    // MARK: - Datum
    struct Datum: Codable {
        let id: Int?
        let file: String?
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }

}
