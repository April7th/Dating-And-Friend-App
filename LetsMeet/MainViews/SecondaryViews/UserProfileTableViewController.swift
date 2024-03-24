//
//  UserProfileTableViewController.swift
//  LetsMeet
//
//  Created by Lê Duy Tân on 14/11/2023.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    //MARK: - Vars
    var userObject: FUser?
    
    var allImage: [UIImage] = []
    
  
    //MARK: - View Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        
        if userObject != nil {
            showUserDetail()
            loadImages()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInsetAdjustmentBehavior = .never

        dislikeButtonOutlet.setTitle("", for: .normal)
        likeButtonOutlet.setTitle("", for: .normal)
        
        
        setupBackground()
        hideActivityIndicator()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //fetch the safe area in layoutSubviews since this it's possible that they can change when the device is rotated
        let safeArea = self.tableView.safeAreaInsets
        //insets are **flipped** because the tableview is flipped over its Y-axis!
        self.tableView.contentInset = .init(top: safeArea.bottom, left: 0, bottom: safeArea.top, right: 0)
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
    //MARK: - Set up UI
    private func setupBackground() {
        
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
    }
    
    //MARK: - Set up User profile
    private func showUserDetail() {
        
        aboutTextView.text = userObject!.about
        professionLabel.text = userObject!.profession
        jobLabel.text = userObject!.jobTitle
        genderLabel.text = userObject!.isMale ? "Male" : "Female"
        heightLabel.text = String(format: "%.2f", userObject!.height)
        lookingForLabel.text = userObject!.lookingFor
    }
    
    private func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    //MARK: - Load Image
    private func loadImages() {
        
        let placeholder = userObject!.isMale ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named: placeholder)
        
        allImage = [avatar!]
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0 {
            showActivityIndicator()
            //show page control
            self.setPageControlPages()
            
            self.collectionView.reloadData()
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                
                self.allImage += returnedImages as! [UIImage]
                //show page control
                self.setPageControlPages()
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }
            }
        } else {
            hideActivityIndicator()
        }
    }

    //MARK: - Page control function
    private func setPageControlPages() {
        
        self.pageControl.numberOfPages = self.allImage.count
    }
    
    private func setSelectedPageTo(page: Int) {
        self.pageControl.currentPage = page
    }
   
}
