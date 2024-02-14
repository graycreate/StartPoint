//
//  NetworkMonitor.swift
//  ULPB
//
//  Created by Gray on 2024/1/24.
//

import Foundation
import Network

public class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    public var isConnected = false

    private init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
  
 public static let shared = NetworkMonitor()
  
}
