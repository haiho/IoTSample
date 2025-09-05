//
//  HealthManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import HealthKit
import SwiftUI

//Time 1h32
class HealthManager {

    static let shared = HealthManager()
    let healthStore = HKHealthStore()

    private init() {
    }

    func requestAuthorization(
        completion: @escaping (Bool, Error) -> Void
    ) {
        guard
            let stepType = HKQuantityType.quantityType(
                forIdentifier: .stepCount
             
            )
        else {
            print("Không thể tạo stepCount type.")
            return
        }
        let status = healthStore.authorizationStatus(for: stepType)

        switch status {
        case .notDetermined:
            // Chưa xin quyền, tiến hành xin
            healthStore.requestAuthorization(toShare: nil, read: [stepType]) {
                success,
                error in
                DispatchQueue.main.async {
                    completion(
                        false,  // need to show msg don't allow permission
                        error
                            ?? NSError(
                                domain: "HealthAuth",
                                code: 1,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Không được cấp quyền HealthKit."
                                ]
                            )
                    )

                }
            }

        case .sharingDenied:
            // Người dùng đã từ chối quyền → hiển thị cảnh báo và hướng dẫn mở Settings
            DispatchQueue.main.async {
                //                      showHealthPermissionAlert()
                let error = NSError(
                    domain: "HealthAuth",
                    code: 2,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Người dùng đã từ chối quyền Health."
                    ]
                )
                completion(false, error)
            }

        case .sharingAuthorized:
            // Có quyền → truy vấn
            completion(true, NSError())

        @unknown default:
            let error = NSError(
                domain: "HealthAuth",
                code: 5,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Trạng thái quyền không xác định."
                ]
            )
            completion(false, error)
        }
    }

    func fetchStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        guard
            let stepType = HKQuantityType.quantityType(
                forIdentifier: .stepCount
            )
        else {
            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Không thể tạo stepCount type."
                        ]
                    )
                )
            )
            return
        }

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let sum = result?.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    completion(.success(steps))
                } else {
                    completion(
                        .failure(
                            NSError(
                                domain: "HealthQuery",
                                code: 1,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Không có dữ liệu bước chân."
                                ]
                            )
                        )
                    )
                }
            }
        }

        healthStore.execute(query)
    }

}
