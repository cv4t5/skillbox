//
//  LogoVIew.swift
//  TemplateProject
//
//  Created by Роман Захарченко on 19.02.2024.
//

import UIKit

class LogoVIew: UIView {
    static func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "LogoVIew", bundle: Bundle(for: LogoVIew.self))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
