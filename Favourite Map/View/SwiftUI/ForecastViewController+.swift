//
//  ForecastViewController+.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import SwiftUI

struct ForecastSceneView: UIViewControllerRepresentable {
    
    var location: BookmarkedLocation?
    
    func makeUIViewController(context: Context) -> ForecastViewController {
        let scene = UIStoryboard.scene(type: ForecastViewController.self)
        scene.viewModel.location = location
        return scene
    }
    
    func updateUIViewController(_ uiViewController: ForecastViewController, context: Context) {
        //
    }
}

struct ForecastScene: View {
    
    var location: BookmarkedLocation?
    
    var body: some View {
        ForecastSceneView(location: location)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct CityScene_Previews: PreviewProvider {
    static var previews: some View {
        ForecastScene(location: BookmarkedLocation.random())
    }
}
