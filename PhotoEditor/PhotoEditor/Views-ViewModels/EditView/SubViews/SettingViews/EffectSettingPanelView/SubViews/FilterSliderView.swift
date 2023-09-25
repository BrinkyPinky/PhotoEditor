//
//  FilterSliderView.swift
//  PhotoEditor
//
//  Created by BrinyPiny on 04.07.2023.
//

import SwiftUI

// MARK: Slider для пролистывания фильтров
struct FilterSliderView<Content: View>: UIViewRepresentable {
    private var content: () -> Content
    let currentPickedEffectChanged: (_ elementNumber: Int) -> ()
    let effectPicked: () -> ()
    
    init(effectPicked: @escaping () -> (), currentPickedEffectChanged: @escaping (_ to: Int) -> (), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.currentPickedEffectChanged = currentPickedEffectChanged
        self.effectPicked = effectPicked
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.showsHorizontalScrollIndicator = false
        
        let hostedView = UIHostingController(rootView: content())
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        hostedView.view.backgroundColor = .clear
        
        scrollView.addSubview(hostedView.view)
        
        NSLayoutConstraint.activate([
            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostedView.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostedView.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: -20)
        ])
        
        DispatchQueue.main.async {
            hostedView.view.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            scrollView.contentSize = hostedView.view.bounds.size
        }
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(currentPickedEffectChanged: currentPickedEffectChanged, effectPicked: effectPicked)
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let currentPickedEffectChanged: (_ elementNumber: Int) -> ()
        let effectPicked: () -> ()
        
        init(currentPickedEffectChanged: @escaping (_: Int) -> Void, effectPicked: @escaping () -> ()) {
            self.currentPickedEffectChanged = currentPickedEffectChanged
            self.effectPicked = effectPicked
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            scrollViewDidStopScrolling(scrollView: scrollView)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                scrollViewDidStopScrolling(scrollView: scrollView)
            }
        }
        
        func scrollViewDidStopScrolling(scrollView: UIScrollView) {
            let numberOfTargetFilter = ((scrollView.contentOffset.x + 10) / 108).rounded(.toNearestOrEven)
            UIView.animate(withDuration: 0.1) {
                scrollView.contentOffset = CGPoint(x: numberOfTargetFilter * 108, y: 0)
            }
            currentPickedEffectChanged(Int(numberOfTargetFilter))
            effectPicked()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let numberOfTargetFilter = ((scrollView.contentOffset.x + 10) / 108).rounded(.toNearestOrEven)
            currentPickedEffectChanged(Int(numberOfTargetFilter))
        }
    }
}
