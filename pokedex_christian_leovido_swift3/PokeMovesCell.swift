//
//  PokeMovesCell.swift
//  pokedex_christian_leovido_swift3
//
//  Created by Christian Leovido on 27/07/2017.
//  Copyright © 2017 Christian Leovido. All rights reserved.
//

import UIKit

class PokeMovesCell: UITableViewCell {

    var pokemon: Pokemon!
    
    @IBOutlet weak var pokemonMoves: UILabel!
    @IBOutlet weak var pokemonLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
