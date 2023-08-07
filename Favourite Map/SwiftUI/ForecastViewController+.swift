//
//  ForecastViewController+.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import SwiftUI

struct CitySceneView: UIViewControllerRepresentable {
    
    var city: BookmarkedLocation?
    
    func makeUIViewController(context: Context) -> ForecastViewController {
        let scene = UIStoryboard.scene(type: ForecastViewController.self)
        scene.viewModel.city = city
        return scene
    }
    
    func updateUIViewController(_ uiViewController: ForecastViewController, context: Context) {
        //
    }
}

struct ForecastScene: View {
    
    var city: BookmarkedLocation?
    
    var body: some View {
        CitySceneView(city: city)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct CityScene_Previews: PreviewProvider {
    static var previews: some View {
        ForecastScene(city: BookmarkedLocation.random())
    }
}
