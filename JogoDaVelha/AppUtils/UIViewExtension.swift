//
//  UIViewExtension.swift
//  JogoDaVelha
//
//  Created by Josicleison on 11/09/22.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        
        for view in views {
            
            self.addSubview(view)
        }
    }
    
    func constraint(to view: Any?,
                    relation: NSLayoutConstraint.Relation = .equal,
                    by: [NSLayoutConstraint.Attribute]? = nil,
                    with attributes: [NSLayoutConstraint.Attribute:NSLayoutConstraint.Attribute]? = nil,
                    multiplier: CGFloat = 1,
                    constant: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let attributes = by {
            
            for attribute in attributes {
                
                self.superview?.addConstraint(NSLayoutConstraint(item: self,
                                                                 attribute: attribute,
                                                                 relatedBy: relation,
                                                                 toItem: view,
                                                                 attribute: attribute,
                                                                 multiplier: multiplier,
                                                                 constant: constant))
            }
        }
        
        if let attributes = attributes {
            
            for attribute in attributes {
                
                self.superview?.addConstraint(NSLayoutConstraint(item: self,
                                                                 attribute: attribute.key,
                                                                 relatedBy: relation,
                                                                 toItem: view,
                                                                 attribute: attribute.value,
                                                                 multiplier: multiplier,
                                                                 constant: constant))
            }
        }
    }
    
    func height(by constant: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}
