//
//  RecordingReportCollectionViewCell.swift
//  M2C
//
//  Created by Abdul Samad Butt on 13/09/2022.
//

import UIKit

class RecordingReportCollectionViewCell: UICollectionViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewCalculations: UIView!
    @IBOutlet weak var txtUnit: UILabel!
    @IBOutlet weak var txtReading: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var viewLock: UIView!
    @IBOutlet weak var txtBottomText: UILabel!
    
    //MARK: OVER-RIDDEN METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: SETUP CELL
    func setupCell(report: RecordingReport){
        viewLine.backgroundColor = report.color
        viewCalculations.borderColor = report.color
        txtTitle.text = report.title
        txtReading.text = report.reading
        txtUnit.text = report.unit
        txtBottomText.text = report.bottomText
        viewCalculations.backgroundColor = .white
        viewLock.hide()
        
        if report.isLocked{
            viewCalculations.backgroundColor = .black.withAlphaComponent(0.5)
            viewLock.unhide()
            txtReading.text = ""
        }
    }
}
