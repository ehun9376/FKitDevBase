//
//  FListView.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class TableViewSectionData<D, T> {
    var header: D?
    var rows: [T]
    
    init(header: D? = nil, rows: [T] = []) {
        self.header = header
        self.rows = rows
    }
}


class FListViewBuilder<D, T>: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var data: [TableViewSectionData<D, T>] = []
    private let cellBuilder: ((T, IndexPath) -> UIView)?
    private let headerBuilder: ((D, Int) -> UIView)?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(data: [TableViewSectionData<D, T>] = [],  headerBuilder: ((D, Int) -> UIView)? = nil, cellBuilder: ((T, IndexPath) -> UIView)? = nil) {
        self.data = data
        self.cellBuilder = cellBuilder
        self.headerBuilder = headerBuilder
        super.init(frame: .zero)
        self.setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(self.tableView)  // 確保 tableView 被加到 FListViewBuilder 視圖中
        self.tableView.reloadData()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.updateTableViewConstraints()
    }
    
    func updateTableViewConstraints() {
        NSLayoutConstraint.deactivate(self.tableView.constraints)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        if let headerData = data[section].header, let header = headerBuilder?(headerData, section) {
            for view in headerView.contentView.subviews {
                view.removeFromSuperview()
            }
            headerView.contentView.addSubview(header)
            header.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: headerView.contentView.topAnchor),
                header.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor),
                header.trailingAnchor.constraint(equalTo: headerView.contentView.trailingAnchor),
                header.bottomAnchor.constraint(equalTo: headerView.contentView.bottomAnchor),
            ])
            return headerView
           
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellView = cellBuilder?(data[indexPath.section].rows[indexPath.row], indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        for cell in cell.contentView.subviews {
            cell.removeFromSuperview()
        }
        cell.selectionStyle = .none
        // 將 cellView 添加到 contentView 中
        cell.contentView.addSubview(cellView)
        
        // 設置 cellView 的約束
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])
        
        return cell
    }
}
