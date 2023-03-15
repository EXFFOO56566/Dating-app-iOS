

import Foundation
class GetMatchModel:BaseModel{
     struct GetMatchSuccessModel: Codable {
         var data: [Datum]?
         var code: Int?
         var message: String?
     }

     // MARK: - Datum
     struct Datum: Codable {
         var id, online, lastseen: Int?
         var username: String?
         var avater: String?
         var country, firstName, lastName, location: String?
         var birthday: String?
         var language: String?
         var relationship: Int?
         var height: String?
         var body, smoke, ethnicity, pets: Int?
         var gender: String?
         var countryText: String?
         var relationshipText, bodyText, smokeText, ethnicityText: String?
         var petsText: String?
         var genderText: String?

         enum CodingKeys: String, CodingKey {
             case id, online, lastseen, username, avater, country
             case firstName = "first_name"
             case lastName = "last_name"
             case location, birthday, language, relationship, height, body, smoke, ethnicity, pets, gender
             case countryText = "country_text"
             case relationshipText = "relationship_text"
             case bodyText = "body_text"
             case smokeText = "smoke_text"
             case ethnicityText = "ethnicity_text"
             case petsText = "pets_text"
             case genderText = "gender_text"
         }
     }

     enum Language: String, Codable {
         case english = "english"
         case french = "french"
     }

     // MARK: - Errors
     struct Errors: Codable {
         var errorID, errorText: String?

         enum CodingKeys: String, CodingKey {
             case errorID = "error_id"
             case errorText = "error_text"
         }
     }

     // MARK: - Encode/decode helpers

     class JSONNull: Codable, Hashable {

         public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
             return true
         }

         public var hashValue: Int {
             return 0
         }

         public init() {}

         public required init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             if !container.decodeNil() {
                 throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
             }
         }

         public func encode(to encoder: Encoder) throws {
             var container = encoder.singleValueContainer()
             try container.encodeNil()
         }
     }

}
