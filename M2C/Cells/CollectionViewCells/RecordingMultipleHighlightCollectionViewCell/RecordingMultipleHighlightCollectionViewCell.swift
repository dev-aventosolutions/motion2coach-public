//
//  RecordingMultipleHighlightCollectionViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 12/10/2022.
//

import UIKit

class RecordingMultipleHighlightCollectionViewCell: UICollectionViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var collectionViewHighlights: UICollectionView!
    
    //MARK: VARIABLES
    var data: [RecordingReport]?
    
    func setupCell(recordingReport: [RecordingReport]){
        
        data = recordingReport
        collectionViewHighlights.registerSingleCell(cellType: RecordingReportCollectionViewCell.self)
        collectionViewHighlights.delegate = self
        collectionViewHighlights.dataSource = self
        collectionViewHighlights.reloadData()
    }
}

//MARK: COLLECTION VIEW METHODS
extension RecordingMultipleHighlightCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(with: RecordingReportCollectionViewCell.self, for: indexPath)
        if let data = data {
//            print(data[indexPath.row].reading)
            cell.setupCell(report: data[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let cellHeight = collectionView.frame.height/3
//        let cellWidth = collectionView.frame.width/3
//        return CGSize(width: cellWidth, height: cellHeight)
        
        let cellWidth = collectionView.frame.width/3.2
        let cellHeight = collectionView.frame.height/3
        
//        print("cell width : \(cellWidth)")
//        print("cell height : \(cellHeight)")
        
        return CGSize(width: cellWidth, height: 70)
    }
    
}
