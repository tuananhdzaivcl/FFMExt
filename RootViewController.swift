import UIKit

class RootViewController: UIViewController {
    
    // 🔑 KEY TĨNH - ĐỔI KEY Ở ĐÂY
    let hardcodedKey: String = "TUAN-ANH-2026-PRO"
    
    var keyTextField: UITextField!
    var messageLabel: UILabel!
    var activateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Kiểm tra đã mở khóa chưa
        if UserDefaults.standard.bool(forKey: "ffmmext_unlocked") {
            showUnlockedScreen()
            return
        }
        
        setupUI()
    }
    
    func setupUI() {
        // Label thông báo
        messageLabel = UILabel()
        messageLabel.text = "Nhập key để kích hoạt FFMMExt"
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        // Ô nhập key
        keyTextField = UITextField()
        keyTextField.placeholder = "XXXX-XXXX-XXXX-XXXX"
        keyTextField.textColor = .white
        keyTextField.backgroundColor = .darkGray
        keyTextField.textAlignment = .center
        keyTextField.autocapitalizationType = .allCharacters
        keyTextField.layer.cornerRadius = 10
        keyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyTextField)
        
        // Nút kích hoạt
        activateButton = UIButton(type: .system)
        activateButton.setTitle("KÍCH HOẠT", for: .normal)
        activateButton.setTitleColor(.white, for: .normal)
        activateButton.backgroundColor = .red
        activateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        activateButton.layer.cornerRadius = 10
        activateButton.addTarget(self, action: #selector(checkKey), for: .touchUpInside)
        activateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activateButton)
        
        // Layout
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: keyTextField.topAnchor, constant: -30),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            keyTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            keyTextField.widthAnchor.constraint(equalToConstant: 300),
            keyTextField.heightAnchor.constraint(equalToConstant: 45),
            
            activateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activateButton.topAnchor.constraint(equalTo: keyTextField.bottomAnchor, constant: 20),
            activateButton.widthAnchor.constraint(equalToConstant: 200),
            activateButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func checkKey() {
        guard let key = keyTextField.text, !key.isEmpty else {
            messageLabel.text = "❌ Vui lòng nhập key!"
            messageLabel.textColor = .red
            return
        }
        
        if key.uppercased() == hardcodedKey {
            messageLabel.text = "✅ Key hợp lệ!"
            messageLabel.textColor = .green
            UserDefaults.standard.set(true, forKey: "ffmmext_unlocked")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showUnlockedScreen()
            }
        } else {
            messageLabel.text = "❌ Key không hợp lệ!"
            messageLabel.textColor = .red
        }
    }
    
    func showUnlockedScreen() {
        // Xóa hết UI cũ
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.text = "✅ FFMMExt đã sẵn sàng!"
        label.textColor = .green
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}