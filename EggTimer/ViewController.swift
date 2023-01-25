//
//  ViewController.swift
//  EggTimer
//
//  Created by Sergey on 24.01.2023.
//

import UIKit
import SnapKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: - Variables
    
    let eggTimes: [String: Int] = ["Soft": 3, "Medium": 5, "Hard": 7]
    var timer = Timer()
    var player: AVAudioPlayer!
    var totalTime = 0
    var secondPassed = 0
   
    //MARK: - Titles
    
    lazy var mainLabel: UILabel = {
        let label = UILabel(frame: LabelProperty().labelFrame)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.font = LabelProperty().labelFont
        label.textAlignment = .center
        label.text = "How do you like your eggs?"
        return label
    }()
    
    lazy var softTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = "Soft"
        return label
    }()
    
    lazy var mediumTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = "Medium"
        return label
    }()
    
    lazy var hardTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = "Hard"
        return label
    }()
    
    //MARK: - Views/StackView
    
    lazy var progressView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 374.0, height: 245.5))
        view.backgroundColor = .clear
        view.alpha = 1.0
        view.addSubview(progressBar)
        return view
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 39.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.mainLabel,
         self.eggsStackView,
         self.progressView].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    lazy var eggsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        [self.softEggView,
         self.mediumEggView,
         self.hardEggView].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    lazy var softEggView: UIView = {
        let view = UIView(frame: ImageViewProperty().imageViewFrame)
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addSubview(softEggButton)
        return view
    }()
    
    lazy var mediumEggView: UIView = {
        let view = UIView(frame: ImageViewProperty().imageViewFrame)
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addSubview(mediumEggButton)
        return view
    }()

    lazy var hardEggView: UIView = {
        let view = UIView(frame: ImageViewProperty().imageViewFrame)
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        view.addSubview(hardEggButton)
        return view
    }()

    
    lazy var softEggImageView: UIImageView = {
        let imageView = UIImageView(frame: ImageViewProperty().imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "soft_egg")
        return imageView
    }()
    
    lazy var mediumEggImageView: UIImageView = {
        let imageView = UIImageView(frame: ImageViewProperty().imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "medium_egg")
        return imageView
    }()
    
    lazy var hardEggImageView: UIImageView = {
        let imageView = UIImageView(frame: ImageViewProperty().imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "hard_egg")
        return imageView
    }()
    
    
    
    //MARK: - Buttons
    
    lazy var softEggButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Soft", for: .normal)
        button.contentMode = .scaleAspectFit
        button.titleLabel?.font = ButtonProperty().buttonFont
        button.setTitleColor(.white, for: .normal)
        button.autoresizesSubviews = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addSubview(softEggImageView)
        button.addSubview(softTitle)
        return button
    }()
    
    lazy var mediumEggButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Medium", for: .normal)
        button.titleLabel?.font = ButtonProperty().buttonFont
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.isEnabled = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addSubview(mediumEggImageView)
        button.addSubview(mediumTitle)
        return button
    }()
    

    
    lazy var hardEggButton: UIButton = {
        let button = UIButton(frame: ButtonProperty().buttonFrame)
        button.setTitle("Hard", for: .normal)
        button.titleLabel?.font = ButtonProperty().buttonFont
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addSubview(hardEggImageView)
        button.addSubview(hardTitle)
        return button
    }()
    
   
//MARK: - Other UI elements
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.center = view.center
        progressView.setProgress(0.5, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.tintColor = .yellow
        return progressView
    }()
 
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.9490196078, blue: 0.9882352941, alpha: 1)
        view.addSubview(verticalStackView)
        
        
        progressBar.snp.makeConstraints { (make) in
            make.centerX.equalTo(progressView)
            make.centerY.equalTo(progressView)
            make.leading.equalTo(progressView).offset(15)
            make.height.equalTo(10)
        }
        
        softTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(softEggImageView)
            make.centerY.equalTo(softEggImageView)
            make.height.equalTo(softEggImageView)
            make.width.equalTo(softEggImageView)
        }
        
        mediumTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(mediumEggImageView)
            make.centerY.equalTo(mediumEggImageView)
            make.height.equalTo(mediumEggImageView)
            make.width.equalTo(mediumEggImageView)
        }
        
        hardTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(hardEggImageView)
            make.centerY.equalTo(hardEggImageView)
            make.height.equalTo(hardEggImageView)
            make.width.equalTo(hardEggImageView)
        }
        
        softEggButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(softEggImageView)
            make.centerY.equalTo(softEggImageView)
            make.height.equalTo(softEggImageView)
            make.width.equalTo(softEggImageView)
        }
        
        mediumEggButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(mediumEggImageView)
            make.centerY.equalTo(mediumEggImageView)
            make.height.equalTo(mediumEggImageView)
            make.width.equalTo(mediumEggImageView)
        }
        
        hardEggButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(hardEggImageView)
            make.centerY.equalTo(hardEggImageView)
            make.height.equalTo(hardEggImageView)
            make.width.equalTo(hardEggImageView)
        }
        
        verticalStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
    }
    
//MARK: - Methods
    
    @objc func buttonTapped(_ sender: UIButton!) {
        switch sender.titleLabel?.text {
        case "Soft":
            mainLabel.text = "Soft"
        case "Medium":
            mainLabel.text = "Medium"
        case "Hard":
            mainLabel.text = "Hard"
        default:
            return
        }
    }
    
}

