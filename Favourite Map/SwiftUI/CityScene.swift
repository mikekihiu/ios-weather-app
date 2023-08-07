//
//  CityScene.swift
//  Favourite Map
//
//  Created by Mike Kihiu on 07/08/2023.
//

import SwiftUI

struct CitySceneView: UIViewControllerRepresentable {
    
    var city: BookmarkedLocation?
    
    func makeUIViewController(context: Context) -> CityViewController {
        let scene = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CityViewController") as? CityViewController ?? CityViewController()
        scene.viewModel.city = city
        return scene
    }
    
    func updateUIViewController(_ uiViewController: CityViewController, context: Context) {
        //
    }
}

struct CityScene: View {
    
    var city: BookmarkedLocation?
    
    var body: some View {
        CitySceneView(city: city)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct CityScene_Previews: PreviewProvider {
    static var previews: some View {
        CityScene(city: BookmarkedLocation.random())
    }
}
