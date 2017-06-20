//
//  ViewController.swift
//  Pokemon
//
//  Created by Viktoria on 7/14/16.
//  Copyright © 2016 Viktoria. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pocemonCollectionView: UICollectionView!
    @IBOutlet weak var musicBtnPressed: UIButton!
    
    var pokemon = [Pokimon]()
    var filteredPkemon = [Pokimon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pocemonCollectionView.delegate = self
        pocemonCollectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        initAudio()
        parsePokemonCSV()
    }
    func initAudio(){
       let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        
        } catch let err as NSError {
    print(err.debugDescription)
    }

    }
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for rows in rows {
                let pokeId = Int(rows["id"]!)!
                let name = rows["identifier"]!
                let poke = Pokimon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
          //  print(rows)
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPkemon.count
        } else {
             return pokemon.count
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokeCell{
            
            let poke: Pokimon!
            if inSearchMode {
                poke = filteredPkemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokimon!
        if inSearchMode {
            
         poke = filteredPkemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        print(poke.name)
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton!) {
        if musicPlayer.isPlaying{
           musicPlayer.stop()
            sender.alpha = 0.2
        } else {
           musicPlayer.play()
            sender.alpha = 1
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            pocemonCollectionView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPkemon = pokemon.filter({$0.name.range(of: lower) != nil})
            pocemonCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokimon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}

