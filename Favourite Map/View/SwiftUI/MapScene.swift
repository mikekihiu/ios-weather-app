//
//  MapScene.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import SwiftUI
import MapKit

fileprivate struct MapSceneView: UIViewControllerRepresentable {
    
    let viewModel: MapViewViewModel
    
    func makeUIViewController(context: Context) -> MapViewController {
        let scene = UIStoryboard.scene(type: MapViewController.self)
        scene.viewModel = viewModel
        return scene
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        //
    }
}

struct MapScene: View {
    
    let viewModel: MapViewViewModel
    @State private var showForecast = false
    
    var body: some View {
        ZStack {
            MapSceneView(viewModel: viewModel)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "chevron.up")
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .onTapGesture {
                            showForecast.toggle()
                        }
                }.padding(16)
            }
        }.edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showForecast) {
                ForecastScene(location: viewModel.location)
            }
    }
}

struct MapScene_Previews: PreviewProvider {
    static var previews: some View {
        MapScene(
            viewModel: MapViewViewModel(
                mapItem: MKMapItem(),
                boundingRegion: MKCoordinateRegion())
        )
    }
}
