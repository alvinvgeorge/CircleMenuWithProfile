//
//  CircleMenuButton.swift

import UIKit

internal class CircleMenuButton: UIButton {
    
    // MARK: properties
    weak var container: UIView?
    var appUIColor_First:UIColor = UIColor(rgb: 0x3F51B5)
    
    
    // MARK: life cycle
    
    init(size: CGSize, platform: UIView, distance: Float, angle: Float = 0) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = size.height / 2.0
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 0)
        
        let aContainer = createContainer(CGSize(width: size.width, height:CGFloat(distance)), platform: platform)
        
        
        // For Label on Top Of Button
        // let titleLabel = UILabel(frame: CGRect(x: self.frame.origin.x - self.frame.midX , y: self.frame.origin.y - (self.frame.midX + 10), width: self.frame.size.width * 2, height: self.frame.size.height))
        
        
        
        //        let titleLabel = UILabel(frame: CGRect(x: self.frame.origin.x - self.frame.midX , y: self.frame.origin.y + (self.frame.midX + 10), width: self.frame.size.width * 2, height: self.frame.size.height))
        //        titleLabel.text = "NOTIFICATIONS"
        //        titleLabel.font = UIFont(name: "Arial", size: 12.0)
        //        titleLabel.textAlignment =  .center
        //        titleLabel.textColor =  UIColor.black
        //        titleLabel.allowsDefaultTighteningForTruncation =  true
        //
        //        self.addSubview(titleLabel)
        
        
        
        
        // hack view for rotate
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        view.backgroundColor = UIColor.clear
        view.addSubview(self)
        //...
        
        aContainer.addSubview(view)
        container = aContainer
        
        view.layer.transform = CATransform3DMakeRotation(-CGFloat(angle.degrees), 0, 0, 1)
        
        self.rotatedZ(angle: angle, animated: false)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure
    fileprivate func createContainer(_ size: CGSize, platform: UIView) -> UIView {
        let container = Init(UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))) {
            $0.backgroundColor                           = UIColor.clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.anchorPoint                         = CGPoint(x: 0.5, y: 1)
        }
        platform.addSubview(container)
        
        // added constraints
        let height = NSLayoutConstraint(item: container,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .height,
                                        multiplier: 1.2,
                                        constant: size.height)
        height.identifier = "height"
        container.addConstraint(height)
        
        container.addConstraint(NSLayoutConstraint(item: container,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .width,
                                                   multiplier: 1.2,
                                                   constant: size.width))
        
        platform.addConstraint(NSLayoutConstraint(item: platform,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: container,
                                                  attribute: .centerX,
                                                  multiplier: 1,
                                                  constant:0))
        
        platform.addConstraint(NSLayoutConstraint(item: platform,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: container,
                                                  attribute: .centerY,
                                                  multiplier: 1,
                                                  constant:0))
        
        return container
    }
    
    // MARK: methods
    
    internal func rotatedZ(angle: Float, animated: Bool, duration: Double = 0, delay: Double = 0) {
        guard let container = self.container else {
            fatalError("contaner don't create")
        }
        
        let rotateTransform = CATransform3DMakeRotation(CGFloat(angle.degrees), 0, 0, 1)
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: UIViewAnimationOptions(),
                animations: { () -> Void in
                    container.layer.transform = rotateTransform
            },
                completion: nil)
        } else {
            container.layer.transform = rotateTransform
        }
    }
}

// MARK: Animations

internal extension CircleMenuButton {
    
    internal func showAnimation(distance: Float, duration: Double, delay: Double = 0) {
        guard let heightConstraint = (self.container?.constraints.filter {$0.identifier == "height"})?.first else {
            fatalError()
        }
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.container?.superview?.layoutIfNeeded()
        
        self.alpha = 0
        
        heightConstraint.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                self.container?.superview?.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
        }, completion: { (success) -> Void in
        })
    }
    
    internal func hideAnimation(distance: Float, duration: Double, delay: Double = 0) {
        guard let heightConstraint = (self.container?.constraints.filter {$0.identifier == "height"})?.first else {
            return
        }
        
        heightConstraint.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                self.container?.superview?.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { (success) -> Void in
            self.alpha = 0
            
            if let _ = self.container {
                self.container?.removeFromSuperview() // remove container
            }
        })
    }
    
    internal func changeDistance(_ distance: CGFloat, animated: Bool, duration: Double = 0, delay: Double = 0) {
        
        guard let heightConstraint = (self.container?.constraints.filter {$0.identifier == "height"})?.first else {
            fatalError()
        }
        
        heightConstraint.constant = distance
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                self.container?.superview?.layoutIfNeeded()
        },
            completion: nil)
    }
    
    // MARK: layer animation
    
    internal func rotationAnimation(_ angle: Float, duration: Double) {
        let rotation = Init(CABasicAnimation(keyPath: "transform.rotation")) {
            $0.duration       = TimeInterval(duration)
            $0.toValue        = (angle.degrees)
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        container?.layer.add(rotation, forKey: "rotation")
    }
}
