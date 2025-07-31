//
//  Audio.swift
//  Jorgensen
//
//  Created by Apple on 04/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Audio: UIViewController, UITextFieldDelegate {

    let cellReuseIdentifier = "audioTableCell"
    var matchIdSelect: String!
    var matchTitleSelect: String!
    var matchCategory: String!
    var matchSubCategory: String!
    var dictevent = [String: Any]()
    var searchArrRes = [[String: Any]]()
    var originalArr = [[String: Any]]()
    var searching = false
    var devesionIdCategory: String!
    var matchTitleShowSelect: String!

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var feeTextField: UITextField!

    @IBOutlet weak var navigationBar: UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    @IBOutlet weak var lblNavigationTitle: UILabel! {
        didSet {
            lblNavigationTitle.text = self.matchTitleShowSelect.uppercased()
            lblNavigationTitle.textColor = .white
        }
    }

    @IBOutlet weak var btnBack: UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }

    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor = .clear
            tbleView.tableFooterView = UIView()
            tbleView.separatorColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        setupBackButton()
        setupActivityIndicator()
        loadAllItemsOnce()
    }

    private func setupBackButton() {
        let userDefault = UserDefaults.standard
        if userDefault.string(forKey: "keySidebarOrBack") == "sideBar" {
            btnBack.setBackgroundImage(UIImage(named: "menu"), for: .normal)
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController()?.rearViewRevealWidth = 300
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        } else {
            btnBack.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
    }

    private func loadAllItemsOnce() {
        activityIndicator.startAnimating()

        let url = URL(string: "https://www.powerflexweb.com/api_content/common/read.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = "id_language=en-US&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZF9lYXAiOiIxNjUxIiwiaWRfY29tcGFueSI6MTY1MTI2NTY3fQ.FznzxAPBbFF9kI2Vd6G39P6kO431dztk8TN9VYir-jY&api_id=1651&id_module=\(matchCategory!)&id-category=\(matchSubCategory!)&id_element=\(matchIdSelect!)&id_division=\(devesionIdCategory!)&columns=id_cr,title,id_element,body_combine&order_by=title&order_direction=asc&top_content="

        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }

            guard error == nil, let data = data else {
                self.showAlert(error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                if let content = json?["content"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.originalArr = content
                        self.tbleView.reloadData()
                    }
                } else if let msg = json?["message"] as? String {
                    self.showAlert(msg)
                }
            } catch {
                self.showAlert(error.localizedDescription)
            }
        }.resume()
    }

    private func showAlert(_ message: String) {
        DispatchQueue.main.async {
            Alert.showTostMessage(message: message, delay: 3.0, controller: self)
        }
    }

    @objc func backClickMethod() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tbleView.reloadData()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = textField.text! + string
        searchArrRes = originalArr.filter {
            ($0["title"] as? String ?? "").localizedCaseInsensitiveContains(searchText)
        }
        searching = !searchArrRes.isEmpty
        tbleView.reloadData()
        return true
    }
}

extension Audio: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchArrRes.count : originalArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AudioTableCell
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.accessoryType = .disclosureIndicator
        cell.selectedBackgroundView = UIView()

        dictevent = searching ? searchArrRes[indexPath.row] : originalArr[indexPath.row]
        cell.lblName.text = dictevent["title"] as? String ?? ""

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dictevent = searching ? searchArrRes[indexPath.row] : originalArr[indexPath.row]

        let push = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailsId") as? ArticleDetails
        push?.dictdetail = dictevent as NSDictionary
        navigationController?.pushViewController(push!, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // ❌ Removed scrollViewDidScroll (no pagination needed)
}

