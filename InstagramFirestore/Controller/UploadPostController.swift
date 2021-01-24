//
//  UploadPostController.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 24/01/21.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func shouldReturnToMainTab(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var captionTextView: UITextView = {
        let tv = InputTextView()
        tv.placeholderText = "Entrer caption..."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Services
    
    // MARK: - Actions
    
    @objc func handleCancel() {
        self.delegate?.shouldReturnToMainTab(self)
    }
    
    @objc func handleSharePost() {
        showLoader(true)
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        
        PostService.uploadPost(caption: caption, image: image) { error in
            self.showLoader(false)
            if let error = error {
                print("FAILED TO UPLOAD POST \(error.localizedDescription)")
                return
            }
            
            self.delegate?.shouldReturnToMainTab(self)
        }
    }
    
    // MARK: - Helpers
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.title = "Share Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(handleSharePost))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
    }
}

// MARK: - UITextFieldDelegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        checkMaxLength(textView)
        
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
