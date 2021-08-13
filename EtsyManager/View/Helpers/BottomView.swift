//
//  SwiftUIView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 13.08.2021.
//


import SwiftUI

struct BottomView<Content: View>: UIViewRepresentable {
    @Binding var presentationMode: PresentationMode
    private var content: () -> Content

    init(presentation: Binding<PresentationMode>, @ViewBuilder _ content: @escaping () -> Content) {
        _presentationMode = presentation
        self.content = content
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        DispatchQueue.main.async {
            if let window = view.window {
                let holder = UIView()
                context.coordinator.holder = holder

                // simple demo background to make it visible
                holder.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor

                holder.translatesAutoresizingMaskIntoConstraints = false

                window.addSubview(holder)
                holder.heightAnchor.constraint(equalToConstant: 140).isActive = true
                holder.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
                holder.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0).isActive = true
                holder.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0).isActive = true

                if let contentView = UIHostingController(rootView: content()).view {
                    contentView.backgroundColor = UIColor.clear
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    holder.addSubview(contentView)

                    contentView.topAnchor.constraint(equalTo: holder.topAnchor, constant: 0).isActive = true
                    contentView.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: 0).isActive = true
                    contentView.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: 0).isActive = true
                    contentView.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: 0).isActive = true
                }
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if !presentationMode.isPresented {
            context.coordinator.holder.removeFromSuperview()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var holder: UIView!

        deinit {
            holder.removeFromSuperview()
        }
    }
}
