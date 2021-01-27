//
//  RegistrationController.swift
//  InstagramFirestore
//
//  Created by Vitor Trimer on 20/01/21.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Full name")
        tf.autocapitalizationType = .words
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    private lazy var usernameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.returnKeyType = .send
        tf.delegate = self
        
        return  tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private let haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Sign In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Actions
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        case fullNameTextField:
            viewModel.fullname = sender.text
        case usernameTextField:
            viewModel.username = sender.text
        default:
            break
        }
        
        updateForm()
    }
    
    @objc func handleProfilePhoto() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        showLoader(true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials) { error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, usernameTextField, registerButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerX(inView: view)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

//MARK: - FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        registerButton.backgroundColor = viewModel.buttonBackgroundColor
        registerButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        registerButton.isEnabled = viewModel.formIsValid
    }
    
}

//MARK: - UIImagePickerController

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}

extension RegistrationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            fullNameTextField.becomeFirstResponder()
        case fullNameTextField:
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            handleSignUp()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

