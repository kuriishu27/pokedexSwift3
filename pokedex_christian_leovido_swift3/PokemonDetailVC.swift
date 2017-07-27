//
//  PokemonDetailVC.swift
//  pokedex_christian_leovido_swift3
//
//  Created by Christian Leovido on 15/09/2016.
//  Copyright © 2016 Christian Leovido. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!
    
    @IBOutlet weak var tableViewMoves: UITableView!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    @IBOutlet weak var bioMovesSelector: UISegmentedControl!
    @IBAction func bioMovesSelector(_ sender: Any) {
        
        print("selected")
        print(bioMovesSelector.selectedSegmentIndex)
        
        if bioMovesSelector.selectedSegmentIndex == 0 {
            
            movesAndLevelStack.isHidden = true
            tableViewMoves.isHidden = true
            statsView.isHidden = false
            
        } else {
            
            tableViewMoves.isHidden = false
            movesAndLevelStack.isHidden = false

            statsView.isHidden = true
        }
        
    }
    @IBOutlet weak var statsView: UIStackView!
    
    @IBOutlet weak var movesAndLevelStack: UIStackView!
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMoves.isHidden = true
        movesAndLevelStack.isHidden = true
        
        nameLbl.text = pokemon.name.capitalized
        tableViewMoves.delegate = self
        tableViewMoves.dataSource = self
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetail {
            
            self.updateUI()
            self.tableViewMoves.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            
            evoLbl.text = "No evolutions"
            nextEvoImg.isHidden = true
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableViewMoves.dequeueReusableCell(withIdentifier: "MovesCell", for: indexPath) as! PokeMovesCell
            
            cell.pokemonMoves.text = pokemon.moves[indexPath.row]["name"] as! String
            cell.pokemonLevel.text = String(pokemon.moves[indexPath.row]["level"] as! Int)

            return cell
//        return UITableViewCell()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
