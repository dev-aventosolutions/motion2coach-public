////
////  CalendarVC.swift
////  M2C
////
////  Created by Muhammad Bilal Hussain on 17/05/2022.
////
//
//import UIKit
//class CalendarVC: BaseVC {
//
//    @IBOutlet weak var calendarView: UIView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let calendar = CalendarView(initialContent: makeContent())
//        // Do any additional setup after loading the view.
//    }
//
////    private func makeContent() -> CalendarViewContent {
//      let calendar = Calendar.current
//
//      let startDate = calendar.date(from: DateComponents(year: 2022, month: 01, day: 01))!
//      let endDate = calendar.date(from: DateComponents(year: 2030, month: 12, day: 31))!
//
//      return CalendarViewContent(
//        calendar: calendar,
//        visibleDateRange: startDate...endDate,
//        monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
//    }
//
//    func addCalendar(calendarView: CalendarView){
//        self.calendarView.addSubview(calendarView)
//
//        calendarView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//          calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//          calendarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//          calendarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//          calendarView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
//        ])
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
