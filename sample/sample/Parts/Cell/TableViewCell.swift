//
//  TableViewCell.swift
//  sample
//
//  Created by 水野祥子 on 2020/04/16.
//  Copyright © 2020 sachiko. All rights reserved.
//

import UIKit

protocol tableViewCellProtocol:class {
    func readButtonTap(index:Int)
}

final class TableViewCell: UITableViewCell {
    
    var delegate:tableViewCellProtocol?
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var readButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setRead(){
        self.readButton.setTitle("既読", for: .normal)
        self.readButton.backgroundColor = .read
    }
    
    func setUnread(){
        self.readButton.setTitle("未読", for: .normal)
        self.readButton.backgroundColor = .unread
    }
    
    func set(qiita:Qiita){
        self.titleLabel.text = qiita.title
        self.titleLabel.textColor = .darkGray
        self.readButton.setTitleColor(.white, for: .normal)
        let imgURL = URL(string: qiita.profile_image_url)!
        let session = URLSession(configuration: .default)
        let download = session.dataTask(with: imgURL) { (data, response, error) in
            if (response as? HTTPURLResponse) != nil{
                if let imageData = data {
                    DispatchQueue.main.async {
                        let imageimage = UIImage(data: imageData)
                        self.userImageView.image = imageimage
                    }
                }
            }
        }
        session.invalidateAndCancel()
        download.resume()
    }
    
    func noSet(){
        self.titleLabel.text = "取得に失敗しました"
        self.titleLabel.textColor = .darkGray
        self.readButton.isHidden = true
    }
    
    static let height:CGFloat = 100
    
    @IBAction func readButtonTap(_ sender: UIButton) {
        guard let tableView = (self.superview as? UITableView) else { return }
        guard let indexPath = tableView.indexPath(for: self) else { return }
        
        print(indexPath.row)
        self.delegate?.readButtonTap(index: indexPath.row)
    }
}
