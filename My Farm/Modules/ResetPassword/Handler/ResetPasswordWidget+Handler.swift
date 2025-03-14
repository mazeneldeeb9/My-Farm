//
//  ResetPasswordWidget+Handler.swift
//  TCaptain
//
//  Created by TrianglZ on 08/08/2024.
//

import Foundation

extension ResetPasswordWidget {
    @MainActor
    class Handler: ObservableObject {

        @Published var isLoading = false
        @Published var errorMsg = ""

    }
}
