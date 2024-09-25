//
//  OnBoardingViewController.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import UIKit

class OnBoardingViewController: BaseViewController {
    
    let cellIdentifier: String = "introSlideCell"
    let introSlides: [OnboardingSlide] = OnboardingSlide.setupIntroSlide()
    var currentPage = 0 {
        didSet {
            onboardingPageControl.currentPage = currentPage
            if currentPage == introSlides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }

    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(true, forKey: "LaunchBefore")
    }
    
    override func setupFirstLoadVC() {
        nextButton.setupFilledButton()
        let nib = UINib(nibName: "OnBoardingCollectionViewCell", bundle: .main)
        onboardingCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage != introSlides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(row: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserVC") as! RegisterUserViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        introSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.slide = introSlides[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingCollectionView.frame.width, height: onboardingCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = onboardingCollectionView.frame.width
        currentPage = Int(onboardingCollectionView.contentOffset.x / width)
    }
}
