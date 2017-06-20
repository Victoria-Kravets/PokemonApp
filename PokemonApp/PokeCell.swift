//
//  PokeCell.swift
//  Pokemon
//
//  Created by Viktoria on 7/14/16.
//  Copyright © 2016 Viktoria. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thubImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokimon!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell(_ pokemon: Pokimon){
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thubImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
