//
//  ActiveListingsFilterView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import SwiftUI

struct ActiveListingsFilterView: View {
    @State private var animationAmount: CGFloat = 1
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var sizeClass
    
    @State var values:[CGFloat] = [0,0,1,2,3,4,7,4,5,6,10,5,3,2,1,0,0,1,2,1,0,0,5,0,1,2,0,0,0,0,0,0,0]
        
    @State var pos1:CGFloat = 0.0
    @State var pos2:CGFloat = 1.0

    @State var activeColor:Color = .black
    @State var inactiveColor:Color = .gray
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Text("Filters for active listings")
                        .fontWeight(.heavy)
                       // .font(.title)
                    Button("Discharge") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    .font(.caption)
                    .foregroundColor(.black)
                    
                }
                Divider()
                Spacer()
            }//Intro VStack close
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .top)
            
            VStack (spacing: 30) {
                HStack {
                    Spacer()
                           Text("Sort by")
                               .font(Font.headline)
                        Spacer()
                           RadioButtonGroups { selected in
                               print("Selected Gender is: \(selected)")
                           }
                    Spacer()
                }//HStack 1
                .padding([.leading, .trailing], 10)
                Divider()
                VStack(spacing: 30) {
                    Text("Price filter")
                        .font(Font.headline)
                    GeometryReader { geometry in
                        ZStack(alignment: .center) {
                            // Bar Graph
                            BarGraph(values: self.values, pos1: self.$pos1, pos2: self.$pos2, activeColor: self.activeColor, inactiveColor: self.inactiveColor)

                            // ComboSlider
                            ComboSlider(inactiveColor: self.inactiveColor, activeColor: self.activeColor, pos1: self.$pos1, pos2: self.$pos2)
                                .position(x: geometry.size.width/2.0, y: geometry.size.height + 5)

                        }
                    }
                    .frame(width: nil, height: 100, alignment: .center)
                                   .padding(.horizontal, 25)
                }
                
            }//VStack for 3 criterias
             .padding([.leading, .trailing], 20)
                 Spacer()

              // button moved from here into below background view !!

            }.background(BottomView(presentation: presentationMode) {
             Button {
                 presentationMode.wrappedValue.dismiss()
                 UserDefaults.standard.set(true, forKey: "LaunchedBefore")
             } label: {
                 Text("Apply")
                     .fontWeight(.medium)
                     .padding([.top, .bottom], 15)
                     .padding([.leading, .trailing], 90)
                     .background(Color.black)
                     .foregroundColor(.white)
                     .cornerRadius(15)
                    .scaledToFill()
             }

            })
            //Main VStack
    }
}


/*
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
*/
