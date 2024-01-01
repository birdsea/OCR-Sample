//
//  VisionKitSample.swift
//  OCR-Sample
//
//  Created by birdsea on 2024/01/02.
//

import Foundation
import VisionKit

final class OCR_SampleModel: NSObject, ObservableObject {
    @Published var imageArray: [UIImage] = []
    @Published var textArray: [String] = []
    
    func getDocumentCameraViewController() -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = self
        return vc
    }
}
extension OCR_SampleModel: VNDocumentCameraViewControllerDelegate {
    
    func documentCameraViewControllerDidCancel(
        _ controller: VNDocumentCameraViewController
    ) {
        controller.dismiss(
            animated: true
        )
    }
    
    @MainActor func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFinishWith scan: VNDocumentCameraScan
    ) {
        
        var analyzerConfiguration = ImageAnalyzer.Configuration(
            [.text]
        )
        analyzerConfiguration.locales = ["ja"]
        let analyzer = ImageAnalyzer()
        let interaction = ImageAnalysisInteraction()
        
        for i in 0..<scan.pageCount {
            self.imageArray.append(
                scan.imageOfPage(
                    at: i
                )
            )
            
            // 画像から文字を解析して取得する
            Task {
                let analysis = try? await analyzer.analyze(
                    scan.imageOfPage(
                        at: i
                    ),
                    configuration: analyzerConfiguration
                )
                if let analysis = analysis {
                    interaction.analysis = analysis
                    interaction.preferredInteractionTypes = .automatic
                    interaction.selectableItemsHighlighted = true
                    interaction.allowLongPressForDataDetectorsInTextMode = true
                    
                    self.textArray.append(
                        analysis.transcript
                    )
                }
            }
        }
        
        controller.dismiss(
            animated: true
        )
        
    }
}
