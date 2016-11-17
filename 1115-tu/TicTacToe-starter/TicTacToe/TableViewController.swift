//
//  TableViewController.swift
//  TicTacToe
//
//  Created by 小林和宏 on 11/15/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UITableViewController {
  
  let boards: Variable<[Board]> = Variable([])
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = nil
    tableView.dataSource = nil
    
    boards.asObservable().bindTo(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row: Int, board: Board, cell: UITableViewCell) -> (Void) in
      if let winner = board.winner() {
        cell.textLabel?.text = "Winner: \(winner)"
      } else {
        cell.textLabel?.text = "Current: \(board.playerWithCurrentTurn().rawValue)"
      }
    }.addDisposableTo(disposeBag)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? ViewController {
      destinationViewController.addBoard = { (board: Board) in
        self.boards.value.append(board)
      }
    }
  }
  
}
