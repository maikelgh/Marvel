//
//  ExpandableView.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import UIKit

enum ExpandableViewType {
    case comic, serie, story, event, url
}

struct ExpandableViewModel {
    var type: ExpandableViewType?
    var title: String = ""
    var icon: UIImage = UIImage()
    var expandables: [Any] = []
    var unexpandables: [Any] = []
    var fixed: [Any] = []
    var isExpanded: Bool = false
}

protocol ExpandableViewDelegate: AnyObject {
    func didSelectItem(urlString: String)
}

class ExpandableView: RoundShadowView {

    @IBOutlet weak var headerRed: CustomRedHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackview: UIStackView!
    
    var info = ExpandableViewModel()
    var items: [Any] = []
    var isExpanded: Bool = false
    var identifier: String = ""
    weak var delegate: ExpandableViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTableView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
    }
    
    private func configTableView() {
        tableView.separatorColor = UIColor.red
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false

        // Register cells
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier)

        // Add taps to header
        let tapHeaderRed = UITapGestureRecognizer(target: self, action: #selector(collapseExpand))

        headerRed.isUserInteractionEnabled = true
        headerRed.addGestureRecognizer(tapHeaderRed)
    }
    
    func config(model: ExpandableViewModel, identifier: String = "", hasError: Bool = false) {
        self.identifier = identifier
        tableView.separatorStyle = .singleLine
        info = model
        self.isExpanded = model.isExpanded

        headerRed.isHidden = false
        headerRed.config(title: model.title)
        
        tableView.allowsSelection = info.type == .url

        reloadItems()
    }
    
    func reloadItems() {
        items = []
        if isExpanded {
            items.append(contentsOf: info.fixed)
            items.append(contentsOf: info.expandables)
            ui {
                self.headerRed.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                self.headerRed.roundCorners(corners: [.topLeft, .topRight], radius: 8)
                self.headerRed.button.setImage("icon-arrowdown".image, for: .normal)
            }
            
        } else {
            items.append(contentsOf: info.fixed)
            items.append(contentsOf: info.unexpandables)
            ui {
                self.headerRed.roundCorners(corners: [.topLeft, .topRight,.bottomLeft, .bottomRight], radius: 8)
                self.headerRed.isUserInteractionEnabled = !(self.info.expandables.isEmpty && self.info.unexpandables.isEmpty)
                self.headerRed.button.setImage("icon-arrowup".image, for: .normal)
            }
            
        }
        
        self.tableView.reloadData()

        ui {
            self.layoutSubviews()
        }
    }

    @IBAction func collapseExpand(_ sender: Any) {
        isExpanded = !isExpanded
        reloadItems()
    }
    
    func getRows() -> Int {
        return isExpanded ? info.expandables.count + info.fixed.count : info.fixed.count + info.unexpandables.count
    }
}

extension ExpandableView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch info.type {
        case .comic:
            guard let item = item as? ComicSummary else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            cell.label.text = item.name

            return cell
        case .serie:
            guard let item = item as? SeriesSummary else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            cell.label.text = item.name

            return cell
        case .story:
            guard let item = item as? StorySummary else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            cell.label.text = item.name

            return cell
        case .event:
            guard let item = item as? EventSummary else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            cell.label.text = item.name

            return cell
        case .url:
            guard let item = item as? URLMarvel else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            cell.url = item.url
            cell.label.text = "Link web \(indexPath.row+1)"

            return cell
        default: break

        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        
        switch info.type {
        case .url:
            guard let item = item as? URLMarvel else {
                return
            }
            self.delegate?.didSelectItem(urlString: item.url ?? "")
        default: break

        }
    }
}
