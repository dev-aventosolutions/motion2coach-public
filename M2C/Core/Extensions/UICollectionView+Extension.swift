//
//  UICollectionView+Extension.swift
//  M2C
//
//  Created by Abdul Samad Butt on 22/07/2022.
//

import Foundation
import UIKit

extension UICollectionView{
    
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    
    private func reuseIndentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    // To register single cell
    public func registerSingleCell<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    // To register multiple cells
    public func registerMultipleCells<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { registerSingleCell(cellType: $0) }
    }
    
    // To register single Header Footer View
    public func registerHeaderFooter<T: UICollectionReusableView>(HeaderFooterType: T.Type) {
        let className = HeaderFooterType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    // To register multiple Header Footer View
    public func registerHeaderFooter<T: UICollectionReusableView>(HeaderFooterTypes: [T.Type]) {
        HeaderFooterTypes.forEach { registerHeaderFooter(HeaderFooterType: $0) }
    }
    
    // DequeueReuableCell
    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
}
