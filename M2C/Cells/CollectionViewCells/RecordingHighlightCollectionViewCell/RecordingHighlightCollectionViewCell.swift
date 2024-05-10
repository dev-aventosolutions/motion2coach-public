//
//  RecordingHighlightCollectionViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 10/10/2022.
//

import UIKit

class RecordingHighlightCollectionViewCell: UICollectionViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var collectionViewReport: UICollectionView!
    
    //MARK: VARIABLES
    var data: [RecordingReport]?
    
    
    func setupCell(recordingReport: [RecordingReport]){
        
        data = recordingReport
        collectionViewReport.registerSingleCell(cellType: RecordingReportCollectionViewCell.self)
        collectionViewReport.delegate = self
        collectionViewReport.dataSource = self
        
        collectionViewReport.reloadData()
    }
    
}

//MARK: COLLECTION VIEW METHODS
extension RecordingHighlightCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecordingReportConstants.arrReport.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: RecordingReportCollectionViewCell.self, for: indexPath)
        if let data = data{
            cell.setupCell(report: data[indexPath.row])
        } else {
            print("no data found")
        }
//        cell.setupCell(report: data?[0][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width/3.2
//        let cellHeight = collectionView.frame.height/3
        
//        print("cell width : \(cellWidth)")
//        print("cell height : \(cellHeight)")
        
        return CGSize(width: cellWidth, height: 69)
    }
    
    
}
