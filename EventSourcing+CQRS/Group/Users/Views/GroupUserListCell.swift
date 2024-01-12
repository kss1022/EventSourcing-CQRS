//
//  GroupUserListCell.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import UIKit


final class GroupUserListCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        //nothing to do
    }
        
    func bindView(_ viewModel: GroupUserListViewModel){
        var content = defaultContentConfiguration()
        content.textProperties.font = .getFont(style: .callout)
        content.text = viewModel.name
        contentConfiguration = content
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
    }
    
}
