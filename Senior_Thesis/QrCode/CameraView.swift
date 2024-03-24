//  CameraView.swift
//


import SwiftUI
import CodeScanner

@MainActor
final class CameraViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadcurrentUser() async throws {
        let authDataResult = try  AuthentaticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func addScannedQr(text: String) {
        guard let user else{ return }
        
        Task {
            try await UserManager.shared.addScannedQr(userId:user.userId,qrCode: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

struct CameraViewDemo: View {
    @StateObject private var viewModel = CameraViewModel()
    @State var isPresentingScanner = false
    @State var scannedCode: String = "Scan a Qr code to take your attendance."
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes:[.qr],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code.string
                    viewModel.addScannedQr(text: code.string)
                    //TODO: I want the code.string to be on the user profile once scanned as well make it stored in array
                    self.isPresentingScanner = false
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                Text(scannedCode)
                
                Button("Scan Qr Code"){
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
            }
        }.task  {
            try? await viewModel.loadcurrentUser()
        }
    }
    
}


struct CameraViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        CameraViewDemo()
    }
}
