//
//  ColorsManually.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/6/21.
//

import UIKit

final class ColorsManually: UIViewController {
    
    // MARK: - Properties
    var presenter: ColorsManuallyViewPresenterProtocol!

    @IBOutlet private weak var pickerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var continueButton: UIButton!
    private var collectionViewWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        presenter.setTitleFromRealm()
        presenter.setColorForPicker()
        collectionView.register(ColorCell.nib(), forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction private func continueButtonAction(_ sender: UIButton) {
        presenter.pushResultViewController()
    }
    
    deinit {
        print("Bye: \(self) ")
    }
}

extension ColorsManually: ColorsManuallyViewProtocol {
    
    func setTitle(location: LocationModel) {
        title = "\(location.location): \(location.sampleName)"
    }
    
    
    func setColor(color: UIColor) {
        pickerView.backgroundColor = color
    }
}

extension ColorsManually: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier,
                                     for: indexPath) as? ColorCell else { return UICollectionViewCell()}
        let color = presenter.getColor(index: indexPath)
        cell.setColor(color: color)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x) / Int(collectionViewWidth)
        let index = min(max(0, page), presenter.numberOfItemsInSection() - 1)
        presenter.getCurrentIndexItem(index)
    }
}

extension ColorsManually : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: collectionViewWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
