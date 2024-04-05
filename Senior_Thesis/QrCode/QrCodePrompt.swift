//
//  QrCodePrompt.swift
//  Senior_Thesis
//
//  Created by Christopher Sandoval Terry on 1/19/24.
//

import Foundation
import SwiftUI


struct QrCodePrompt: View {
    @State private var qrCodeContent = "First Qr Code5"

    var body: some View {
        VStack {
            if let qrCodeImage = generateQRCode(from: qrCodeContent) {
                   Image(uiImage: qrCodeImage)
                       .renderingMode(.original)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 200, height: 200)
               } else {
                   Text("Unable to generate QR code")
               }

            Button("Generate New QR Code") {
                
                qrCodeContent = generateRandomString()
            }
        }
        .padding()
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
      
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            QRFilter.setValue("Q", forKey: "inputCorrectionLevel")
            guard let QRImage = QRFilter.outputImage else { return nil }
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(QRImage, from: QRImage.extent) else { return nil }
            return UIImage(cgImage: cgImage)
        }
      
        return nil
    }

    func generateRandomString() -> String {
        return UUID().uuidString
    }
    
}

struct QrCodePrompt_Previews: PreviewProvider {
    
    static var previews: some View {
        QrCodePrompt()
    }
}
