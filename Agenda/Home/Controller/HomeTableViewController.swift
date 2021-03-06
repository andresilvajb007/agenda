//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class HomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var alunoViewController: AlunoViewController?
    var mensagem = Mensagem()
    var alunos: Array<Aluno> = []
    
    var contexto: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.recuperaAlunos()
    }
    
    func recuperaAlunos(){
        Repositorio().recuperaAlunos { (listDeAlunos) in
            self.alunos = listDeAlunos
            self.tableView.reloadData()
        }
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
    

    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer){
        if longPress.state == .began{
            
             let alunoSelecionado = alunos[(longPress.view?.tag)!]
            
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
                    
                case .paginaWeb:
                    
                    if let urlDoAluno = alunoSelecionado.site{
                        var urlFormatada = urlDoAluno
                        
                        if !urlFormatada.hasPrefix("http://"){
                            urlFormatada = String.init(format: "http://%@", urlFormatada)
                        }
                        
                        guard let url = URL(string: urlFormatada) else{ return }
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        let safariViewController = SFSafariViewController(url: url)
                        self.present(safariViewController, animated: true)
                    }
                    
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
            
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alunos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        cell.tag = indexPath.row
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet))
        
        
         let aluno = alunos[indexPath.row]
        
        cell.configura(aluno)
        cell.addGestureRecognizer(longPress)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            AutenticacaoLocal().autorizaUsuario { (autenticado) in
                if autenticado {
                    DispatchQueue.main.async {
                        
                        let alunoSelecionado = self.alunos[indexPath.row]
                        Repositorio().deletaAluno(aluno: alunoSelecionado)
                        self.alunos.remove(at: indexPath.row)
                                                   
                        // Delete the row from the data source
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    
                }
            }
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alunoSelecionado = alunos[indexPath.row]
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
        
        CalculaMediaAPI().calculaMediaGeralDosAlunos(alunos: alunos,
        sucesso: { (dicionario) in
            print(dicionario)
        },
        falha:{ (Error) in
            print(Error)
        })
    }
    @IBAction func buttonLocalizacaoGeral(_ sender: UIBarButtonItem) {
        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
        
        
        
        navigationController?.pushViewController(mapa, animated: true)
    }
    
    //MARK: - SearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nomeDoAluno = searchBar.text else { return }

        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        tableView.reloadData()
    }
}
