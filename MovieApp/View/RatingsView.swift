//
//  RatingsView.swift
//  MovieApp
//
//  Created by Arun Jayasree Kumar on 30/01/20.
//  Copyright © 2020 Arun Jayasree Kumar. All rights reserved.
//

import Foundation
import UIKit



class RatingsView: UIView {
    var view: UIView!
    var ratingsLabel: UILabel!
    let shapeLayer = CAShapeLayer()
    var showAnimation:Bool = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public func setValueForRating(value: (value: Float, isHighRating: Bool)) {
        if showAnimation {
            startAnimating(value: value)
        } else {
            setRatingsValue(value: value)
        }
    }
    
    private func setRatingsValue(value: (value: Float, isHighRating: Bool)) {
        DispatchQueue.main.async { [weak self] in
                   self?.shapeLayer.strokeEnd = CGFloat(value.0)
                   self?.shapeLayer.strokeColor =  value.1 == true ? UIColor.green.cgColor : UIColor.yellow.cgColor
               }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view!)
        self.loadShapeLayer()
        setRatingsLabelConstrains()
        setPercentageLabelConstraints()
    }
    
    func loadShapeLayer() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: view.frame.size.width/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeEnd = 0.001
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        
        view?.layer.addSublayer(shapeLayer)
    }
    
    private func setRatingsLabelConstrains() {
        ratingsLabel = UILabel()
        ratingsLabel.text = "60"
        ratingsLabel.textColor = .white
        ratingsLabel.textAlignment = .center
        ratingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingsLabel)
        NSLayoutConstraint.activate([
            //stick the top of the label to the top of its superview:
            ratingsLabel.topAnchor.constraint(equalTo: view.topAnchor),

            //stick the left of the label to the left of its superview
            //if the alphabet is left-to-right, or to the right of its
            //superview if the alphabet is right-to-left:
            ratingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            //stick the label's bottom to the bottom of its superview:
            ratingsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            //the label's width should be equal to 100 points:
            ratingsLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setPercentageLabelConstraints() {
        
        let label = UILabel()
        label.text = "%"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            //stick the top of the label to the top of its superview:
            label.topAnchor.constraint(equalTo: view.topAnchor),

            //stick the left of the label to the left of its superview
            //if the alphabet is left-to-right, or to the right of its
            //superview if the alphabet is right-to-left:
            label.heightAnchor.constraint(equalToConstant: view.frame.size.width/2),

            //stick the label's bottom to the bottom of its superview:
            label.widthAnchor.constraint(equalToConstant: view.frame.size.height/2),

            //the label's width should be equal to 100 points:
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    func startAnimating(value: (value: Float, isHighRating: Bool)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = value.0
            basicAnimation.duration = 5
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            self?.shapeLayer.lineWidth = 5
            self?.shapeLayer.add(basicAnimation, forKey: "siAnimation")
            self?.setRatingsValue(value: value)
        }
    }
    
    func loadViewFromNib() -> UIView {
        guard let baseView = UINib(nibName: "RatingsView", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first, let ratingView = baseView as? UIView else {
            return UIView()
        }
        return ratingView
    }
}

