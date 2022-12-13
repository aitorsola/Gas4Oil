//
//  MainTabViewViewModel.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 11/3/22.
//

import Foundation

class MainTabViewViewModel: ObservableObject {
    
    @Published var listViewViewModel: StationsListViewViewModel = StationsListViewViewModel()
    @Published var favoriteViewViewModel: FavoriteListViewViewModel = FavoriteListViewViewModel()
}
