//
//  EmailAndNewPassWidget+Handler.swift
//  3oon
//
//  Created by Mazen on 11/02/2025.
//

import Foundation

extension EmailAndNewPassWidget {

    @MainActor
    class Handler: ObservableObject {

        @Published var isLoading = false
        @Published var errorMsg = ""

    }
}
