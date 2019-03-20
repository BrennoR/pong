//
//  ColorPaletteVC.swift
//  CalculatorBR
//
//  Created by Brenno Ribeiro on 5/17/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit

class ColorPaletteVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var colorPalette: UICollectionView!  // color palette collection outlet

    var setting: String!    // used to communicate with settingsVC

    // palette colors
    let colorPaletteColors = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.8672866434, green: 0.8672866434, blue: 0.8672866434, alpha: 1),#colorLiteral(red: 0.7069321066, green: 0.7069321066, blue: 0.7069321066, alpha: 1),#colorLiteral(red: 0.5828640546, green: 0.5828640546, blue: 0.5828640546, alpha: 1),#colorLiteral(red: 0.4313531091, green: 0.4313531091, blue: 0.4313531091, alpha: 1),#colorLiteral(red: 0.2537277919, green: 0.2537277919, blue: 0.2537277919, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 0.8, alpha: 1),#colorLiteral(red: 1, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 1, green: 0.4, blue: 0.4, alpha: 1),#colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.8, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.6, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.8980392157, blue: 0.8, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 0.6, alpha: 1),#colorLiteral(red: 1, green: 0.6980392157, blue: 0.4, alpha: 1),#colorLiteral(red: 1, green: 0.6, blue: 0.2, alpha: 1),#colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1),#colorLiteral(red: 0.8, green: 0.4, blue: 0, alpha: 1),
                              #colorLiteral(red: 0.6, green: 0.2980392157, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0.8, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0.6, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0.4, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0.2, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 0.8, green: 0.8, blue: 0, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0, alpha: 1),#colorLiteral(red: 0.8, green: 1, blue: 0.8, alpha: 1),#colorLiteral(red: 0.6, green: 1, blue: 0.6, alpha: 1),#colorLiteral(red: 0.4, green: 1, blue: 0.4, alpha: 1),#colorLiteral(red: 0.2, green: 1, blue: 0.2, alpha: 1),#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.8, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.6, blue: 0, alpha: 1),#colorLiteral(red: 0.8, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.6, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.4, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.2, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.8, blue: 0.8, alpha: 1),#colorLiteral(red: 0, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.8, green: 0.8980392157, blue: 1, alpha: 1),#colorLiteral(red: 0.6, green: 0.8, blue: 1, alpha: 1),#colorLiteral(red: 0.4, green: 0.6980392157, blue: 1, alpha: 1),#colorLiteral(red: 0.2, green: 0.6, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.4, blue: 0.8, alpha: 1),#colorLiteral(red: 0, green: 0.2980392157, blue: 0.6, alpha: 1),#colorLiteral(red: 0.8, green: 0.8, blue: 1, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 1, alpha: 1),#colorLiteral(red: 0.4, green: 0.4, blue: 1, alpha: 1),#colorLiteral(red: 0.2, green: 0.2, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0.8, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0.6, alpha: 1),#colorLiteral(red: 0.8980392157, green: 0.8, blue: 1, alpha: 1),#colorLiteral(red: 0.8, green: 0.6, blue: 1, alpha: 1),#colorLiteral(red: 0.6980392157, green: 0.4, blue: 1, alpha: 1),#colorLiteral(red: 0.6, green: 0.2, blue: 1, alpha: 1),#colorLiteral(red: 0.4980392157, green: 0, blue: 1, alpha: 1),#colorLiteral(red: 0.4, green: 0, blue: 0.8, alpha: 1),#colorLiteral(red: 0.2980392157, green: 0, blue: 0.6, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.6, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.4, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.2, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0, blue: 1, alpha: 1),#colorLiteral(red: 0.8, green: 0, blue: 0.8, alpha: 1),#colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        colorPalette.delegate = self
        colorPalette.dataSource = self
        
        // layout parameters
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 35, height: 35)
        colorPalette!.collectionViewLayout = layout
        
    }
    
    // dismisses color palette
    @IBAction func removeView(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorPaletteColors.count
    }
    
    // loads color cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorPaletteCell", for: indexPath) as? colorPaletteCell else { return UICollectionViewCell() }
        cell.image.backgroundColor = colorPaletteColors[indexPath.row]
        return cell
    }
    
    // dismisses view and updates respective button color in SettingsVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pickedColor = colorPaletteColors[indexPath.row]
        UserDefaults.standard.setColor(color: pickedColor, forKey: setting)
        NotificationCenter.default.post(name: Notification.Name("updateColors"), object: nil)
        self.view.removeFromSuperview()
    }
    
}
