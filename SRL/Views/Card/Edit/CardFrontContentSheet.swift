//
//  CardFrontContentSheet.swift
//  SRL
//
//  Created by Daniel Koellgen on 23.07.21.
//

import SwiftUI

struct CardFrontContentSheet: ViewModifier {
    @ObservedObject var createCardViewModel: AbstractCardViewModel
    
    @Binding var isShowingBottomSheet: BottomSheetPosition
    @Binding var opacityBottomSheet: Double
    
    @Binding var image: Image?
    @Binding var showingImagePicker: Bool
    @Binding var inputImage: UIImage?
    
    
    func body(content: Content) -> some View {
        content.modifier(CardContentSheet(createCardViewModel: createCardViewModel, isShowingSheet: $isShowingBottomSheet, opacitySheet: $opacityBottomSheet, allowedContentTypes: getAvailableTypes(), image: $image, showingImagePicker: $showingImagePicker, inputImage: $inputImage ,saveAction: appendContentToFront))
    }
    
    
    private func getAvailableTypes() -> [ContentTypeMapper] {
        [.Text, .Image]
    }
    
    private func appendContentToFront(content: CardContentType, cardViewModel: AbstractCardViewModel) {
        cardViewModel.addFrontContent(content)
    }
}