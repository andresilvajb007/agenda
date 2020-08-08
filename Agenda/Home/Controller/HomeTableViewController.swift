//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorDeResultados : NSFetchedResultsController<Aluno>?
    var alunoViewController: AlunoViewController?
    var mensagem = Mensagem()
    
    var contexto: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    // MARK: - Métodos
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno(){
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome =  NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        gerenciadorDeResultados?.delegate = self
        
        do{
            try gerenciadorDeResultados?.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer){
        if longPress.state == .began{
            
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return  }
            
            let menu = MenuOpcoesAlunos().configuraMenudeOpcoesDoAluno { (opcao) in
                
                switch opcao{
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado){
                        
                        componenteMensagem.messageComposeDelegate = self.mensagem                        
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                    
                case .ligacao:
                    guard let numeroDoAluno = alunoSelecionado.telefone else { return }
                    if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    break
                    
                case .waze:
                    
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                            
                        let latitude = String(describing: localizacaoEncontrada.location?.coordinate.latitude)
                        let longitude = String(describing: localizacaoEncontrada.location?.coordinate.longitude)
                            
                        let url : String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                            
                        }
                    }
                    break
                case .mapa:
                     
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as!  MapaViewController
                    mapa.aluno = alunoSelecionado
                    
                    self.navigationController?.pushViewController(mapa, animated: true)
                    
                    break
                    
                }
            }
            self.present(menu, animated: true, completion: nil)
            
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let contadorListaDeAlunos = gerenciadorDeResultados?.fetchedObjects?.count else{
            return 0
        }
        
        return contadorListaDeAlunos
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet))
        
        
        guard let aluno = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else{
            return cell
        }
        
        cell.configura(aluno)
        cell.addGestureRecognizer(longPress)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return  }
            contexto.delete(alunoSelecionado)
            
            do{
                try contexto.save()
            }
            catch{
                print(error.localizedDescription)
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else{
            return            
        }
        
        alunoViewController?.aluno = alunoSelecionado
    }
    
    //MARK: - Fetched Results Controller Delegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            //implementar
            break
        default:
            tableView.reloadData()
        }
    }

    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return }
        CalculaMediaAPI().calculaMediaGeralDosAlunos(alunos: listaDeAlunos,
        sucesso: { (dicionario) in
            print(dicionario)
        },
        falha:{ (Error) in
            print(Error)
        })
    }
}
