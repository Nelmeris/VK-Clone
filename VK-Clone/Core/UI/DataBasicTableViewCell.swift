//
//  DataBasicTableViewCell.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 15/06/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class DataBasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var photo: RoundImageView!
    
    override func awakeFromNib() {
        photo.image = nil
    }
    
    func setPhoto(_ photo: String) {
        guard photo != "" else { return }
        self.photo.sd_setImage(with: URL(string: photo), completed: nil)
    }
    
    func setPhoto(_ photo: String, _ tableView: UITableView, _ indexPath: IndexPath) {
        guard photo != "" else { return }
        
        let getCacheImageOperation = GetCacheImage(url: photo)
        let setImageToRowOperation = SetImageToRow(self, indexPath, tableView)
        
        setImageToRowOperation.addDependency(getCacheImageOperation)
        
        let queue: OperationQueue = {
            let queue = OperationQueue()
            queue.qualityOfService = .userInteractive
            return queue
        }()
        
        queue.addOperation(getCacheImageOperation)
        
        OperationQueue.main.addOperation(setImageToRowOperation)
    }
    
}



class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: DataBasicTableViewCell?
    
    init(_ cell: DataBasicTableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies.first! as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        guard let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath || tableView.indexPath(for: cell) == nil else { return }
        
        cell.photo.image = image
    }
}
