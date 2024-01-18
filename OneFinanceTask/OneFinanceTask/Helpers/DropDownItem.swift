//
//  DropDownItem.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

protocol DropDownItemType {
    var itemTitle: String { get }
}

struct DropDownItem: DropDownItemType {
    let itemTitle: String
}

extension UIViewController {
    func setupMenuDropDown<T: DropDownItemType>(sender: UIButton, disposeBy bag: DisposeBag, items: [T], completion: ((_ item: T) -> Void)?) {
        if #available(iOS 14.0, *) {
            sender.showsMenuAsPrimaryAction = true
        }

        let actions = items.map { item in
            UIAction(title: item.itemTitle) { _ in
                completion?(item)
                sender.setTitle(item.itemTitle, for: .normal)
            }
        }

        if #available(iOS 15.0, *) {
            sender.menu = UIMenu(options: .singleSelection, children: actions)
        } else {
            if #available(iOS 14.0, *) {
                sender.menu = UIMenu(children: actions)
            } else {
                sender.rx.tap.bind { _ in
                    self.showAlertController(sender: sender, items: items, completion: completion)
                }.disposed(by: bag)
            }
        }
    }

    private func showAlertController<T: DropDownItemType>(sender: UIButton, items: [T], completion: ((_ item: T) -> Void)?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.backgroundColor = .white

            popover.sourceRect = CGRect(x: sender.frame.width / 2, y: sender.frame.height + 5, width: 0, height: 0)
        }

        let actions = items.map { item in
            UIAlertAction(title: item.itemTitle, style: .default, handler: { _ in
                completion?(item)
                sender.setTitle(item.itemTitle, for: .normal)
            })
        }

        actions.forEach { alert.addAction($0) }

        alert.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
