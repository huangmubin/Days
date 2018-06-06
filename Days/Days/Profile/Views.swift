//
//  ViewComponent.swift
//  Days
//
//  Created by Myron on 2018/6/5.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/** View Components */
class Views { }

// MARK: - Button

extension Views {
    /** Standard Button */
    class Button {
        
        /** A button use in select, edit place.
         Font = Font.text.m;
         title color = Color.dark;
         background color = Color.gray.light;
         layer.cornerRadius = 10;
         */
        static func normal(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(Color.dark, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = Font.text.m
            button.backgroundColor = Color.gray.light
            return button
        }
        
        /** A button use in select, edit place.
         Font = Font.text.s;
         title color = Color.dark;
         background color = Color.gray.light;
         layer.cornerRadius = 10;
         */
        static func small(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(Color.dark, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = Font.text.s
            button.backgroundColor = Color.gray.light
            return button
        }
        
        /** A warning button use in select, edit place.
         Font = Font.text.m;
         title color = Color.red.light;
         background color = Color.gray.light;
         layer.cornerRadius = 10;
         */
        static func warning(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(Color.red.light, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = Font.text.m
            button.backgroundColor = Color.gray.light
            return button
        }
        
        /** A button in the title place.
         Font = Font.title.b;
         title color = Color.dark;
         background color = Clear;
         layer.cornerRadius = 10;
         */
        static func title(_ value: String = "", alignment: NSTextAlignment = NSTextAlignment.left) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(value, for: .normal)
            button.titleLabel?.font = Font.title.b
            button.setTitleColor(Color.dark, for: .normal)
            button.titleLabel?.textAlignment = alignment
            return button
        }
        
        /** A button in the hint place.
         Font = Font.hint.m;
         title color = Color.dark;
         background color = Clear;
         layer.cornerRadius = 10;
         */
        static func hint(_ title: String, alignment: NSTextAlignment = NSTextAlignment.center) -> UIButton {
            let button = UIButton(type: .system)
            button.titleLabel?.font = Font.hint.m
            button.setTitleColor(Color.dark, for: .normal)
            button.titleLabel?.textAlignment = alignment
            return button
        }
        
        /** System Button, Use the image, default tint color is Color.gray.halftone */
        static func system(image: UIImage?, tint: UIColor = Color.gray.halftone) -> UIButton {
            let button = UIButton(type: UIButtonType.system)
            button.tintColor = tint
            button.setImage(image, for: .normal)
            return button
        }
    }
}

// MARK: - Label

extension Views {
    class Label {
        /** A normal text, in most place. Font.text.m, Color.dark. */
        class func normal(_ value: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = value
            label.textColor = Color.dark
            label.font = Font.text.m
            label.textAlignment = alignment
            label.numberOfLines = line
            label.sizeToFit()
            return label
        }
        
        /** A normal text, in most place. Font.text.m, Color.dark. */
        class func small(_ value: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = value
            label.textColor = Color.dark
            label.font = Font.text.s
            label.textAlignment = alignment
            label.numberOfLines = line
            label.sizeToFit()
            return label
        }
        
        /** A title text, in the title place. Font.title.m, Color.dark. */
        class func title(_ value: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = value
            label.textColor = Color.dark
            label.font = Font.title.b
            label.textAlignment = alignment
            label.numberOfLines = line
            label.sizeToFit()
            return label
        }
        
        /** */
        class func hint(_ value: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = value
            label.textColor = Color.gray.halftone
            label.font = Font.hint.m
            label.textAlignment = alignment
            label.numberOfLines = line
            label.sizeToFit()
            return label
        }
        
        /** */
        class func hint(small: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = small
            label.textColor = Color.gray.halftone
            label.font = Font.hint.s
            label.textAlignment = alignment
            label.numberOfLines = line
            label.sizeToFit()
            return label
        }
        
        /** A title text, in error hint.  */
        class func warning(hint: String, line: Int = 1, alignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.font = Font.hint.m
            label.textColor = Color.red.light
            label.textAlignment = alignment
            label.numberOfLines = line
            label.alpha = 0
            return label
        }
    }
}
