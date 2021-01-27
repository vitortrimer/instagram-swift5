//
//  ResetPasswordController.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 27/01/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPassword(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: ResetPasswordControllerDelegate?
    private var viewModel = ResetPasswordViewModel()
    
    private lazy var emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.returnKeyType = .send
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        return tf
    }()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            self.showLoader(false)
            
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            
            self.delegate?.controllerDidSendResetPassword(self)
        }
    }
    
    @objc func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    
    }
    
}

//MARK: - FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
    
}
