//
//  ExtendedAttributes.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//
import RealmSwift

class ExtendedAttributes: EmbeddedObject, Decodable {
    @Persisted var hdsLastSync: String?
    @Persisted var heightUnit: String?
    @Persisted var weightUnit: String?

    enum CodingKeys: String, CodingKey {
        case hdsLastSync = "hds_last_sync"
        case heightUnit = "height_unit"
        case weightUnit = "weight_unit"
    }
}
