import UIKit
import ObjectiveC

// MARK: - Biến toàn cục để giữ overlay không bị giải phóng
var fovOverlayWindow: UIWindow?

class RootViewController: UIViewController {
    
    // 🔑 KEY TĨNH - ĐỔI KEY Ở ĐÂY
    let hardcodedKey: String = "TUAN-ANH-2026-PRO"
    
    var keyTextField: UITextField!
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Kiểm tra đã mở khóa chưa
        if UserDefaults.standard.bool(forKey: "ffmmext_unlocked") {
            showFakeMenu()
            return
        }
        
        setupKeyUI()
    }
    
    // MARK: - MÀN HÌNH NHẬP KEY
    func setupKeyUI() {
        view.backgroundColor = .black
        
        messageLabel = UILabel()
        messageLabel.text = "🔐 Nhập key để kích hoạt FFMMExt"
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        keyTextField = UITextField()
        keyTextField.placeholder = "XXXX-XXXX-XXXX-XXXX"
        keyTextField.textColor = .white
        keyTextField.backgroundColor = .darkGray
        keyTextField.textAlignment = .center
        keyTextField.autocapitalizationType = .allCharacters
        keyTextField.layer.cornerRadius = 10
        keyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyTextField)
        
        let activateButton = UIButton(type: .system)
        activateButton.setTitle("KÍCH HOẠT", for: .normal)
        activateButton.setTitleColor(.white, for: .normal)
        activateButton.backgroundColor = .red
        activateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        activateButton.layer.cornerRadius = 10
        activateButton.addTarget(self, action: #selector(checkKey), for: .touchUpInside)
        activateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activateButton)
        
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
            UserDefaults.standard.set(true, forKey: "ffmmext_unlocked")
            showFakeMenu()
        } else {
            messageLabel.text = "❌ Key không hợp lệ!"
            messageLabel.textColor = .red
        }
    }
    
    // MARK: - MENU FAKE ĐẦY ĐỦ CHỨC NĂNG
    func showFakeMenu() {
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -30),
        ])
        
        // Tiêu đề
        let titleLabel = UILabel()
        titleLabel.text = "🔥 FFMMExt Menu"
        titleLabel.textColor = .red
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        // Thông tin phiên bản
        let versionLabel = UILabel()
        versionLabel.text = "Version: 1.0.0 | By Tuấn Anh"
        versionLabel.textColor = .gray
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textAlignment = .center
        stackView.addArrangedSubview(versionLabel)
        
        // Khoảng trống
        let spacer1 = UIView()
        spacer1.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(spacer1)
        
        // Danh sách toggle
        let toggles: [(String, Bool)] = [
            ("🎯 AIMBOT", true),
            ("👁️ ESP (Wallhack)", true),
            ("🦘 FLY MODE", false),
            ("🔥 NO RECOIL", true),
            ("⚡ NẠP ĐẠN NHANH", true),
            ("💉 FLASH MEDKIT", false),
            ("🚀 SPEED HACK", false),
            ("🛡️ ANTI-BAN", true),
            ("🎯 AIM HEAD", true),
            ("🔫 AUTO SHOOT", false),
            ("📡 GHOST MODE", false),
            ("💀 ONE SHOT KILL", false),
        ]
        
        for (name, isOn) in toggles {
            let row = createToggleRow(title: name, isOn: isOn)
            stackView.addArrangedSubview(row)
        }
        
        // Khoảng trống
        let spacer2 = UIView()
        spacer2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stackView.addArrangedSubview(spacer2)
        
        // Nút FOV
        let fovButton = createButton(title: "🔴 HIỂN THỊ VÒNG FOV", color: .red)
        fovButton.addTarget(self, action: #selector(showFOVOverlay), for: .touchUpInside)
        stackView.addArrangedSubview(fovButton)
        
        let hideFovButton = createButton(title: "⚫ ẨN VÒNG FOV", color: .darkGray)
        hideFovButton.addTarget(self, action: #selector(hideFOVOverlay), for: .touchUpInside)
        stackView.addArrangedSubview(hideFovButton)
        
        // Nút giả lập
        let fakeButton1 = createButton(title: "🚀 KÍCH HOẠT TẤT CẢ", color: .systemOrange)
        fakeButton1.addTarget(self, action: #selector(showFakeAlert1), for: .touchUpInside)
        stackView.addArrangedSubview(fakeButton1)
        
        let fakeButton2 = createButton(title: "🔄 RESET CÀI ĐẶT", color: .systemBlue)
        fakeButton2.addTarget(self, action: #selector(showFakeAlert2), for: .touchUpInside)
        stackView.addArrangedSubview(fakeButton2)
        
        let fakeButton3 = createButton(title: "📋 COPY LOG", color: .systemGreen)
        fakeButton3.addTarget(self, action: #selector(showFakeAlert3), for: .touchUpInside)
        stackView.addArrangedSubview(fakeButton3)
        
        // Khoảng trống
        let spacer3 = UIView()
        spacer3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.addArrangedSubview(spacer3)
        
        // Footer
        let footerLabel = UILabel()
        footerLabel.text = "© FFMMExt by Tuấn Anh\nKey: TUAN-ANH-2026-PRO"
        footerLabel.textColor = .gray
        footerLabel.font = UIFont.systemFont(ofSize: 11)
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        stackView.addArrangedSubview(footerLabel)
    }
    
    // MARK: - HIỆU ỨNG GIẢ LẬP
    @objc func showFakeAlert1() {
        let alert = UIAlertController(title: "✅ Thành công!", message: "Tất cả chức năng đã được kích hoạt!\nVào game để trải nghiệm!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func showFakeAlert2() {
        let alert = UIAlertController(title: "🔄 Đã reset!", message: "Cài đặt đã về mặc định!\nVui lòng khởi động lại game!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func showFakeAlert3() {
        UIPasteboard.general.string = "[FFMMExt] Aim: 100% | ESP: ON | Ban: OFF | FOV: 200 | Time: \(Date())"
        let alert = UIAlertController(title: "📋 Đã copy!", message: "Log hệ thống đã được copy vào clipboard!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - VÒNG FOV OVERLAY
    @objc func showFOVOverlay() {
        // Ẩn overlay cũ nếu có
        fovOverlayWindow?.isHidden = true
        fovOverlayWindow = nil
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        fovOverlayWindow = UIWindow(frame: UIScreen.main.bounds)
        fovOverlayWindow?.backgroundColor = .clear
        fovOverlayWindow?.isUserInteractionEnabled = false
        fovOverlayWindow?.windowLevel = .alert + 1
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        containerView.backgroundColor = .clear
        fovOverlayWindow?.addSubview(containerView)
        
        // Vòng tròn FOV
        let fovSize: CGFloat = 200
        let fovView = UIView(frame: CGRect(x: (screenWidth - fovSize) / 2,
                                            y: (screenHeight - fovSize) / 2,
                                            width: fovSize,
                                            height: fovSize))
        fovView.backgroundColor = .clear
        fovView.layer.borderColor = UIColor.red.withAlphaComponent(0.8).cgColor
        fovView.layer.borderWidth = 2.5
        fovView.layer.cornerRadius = fovSize / 2
        containerView.addSubview(fovView)
        
        // Dấu chấm ở giữa
        let centerDot = UIView(frame: CGRect(x: (screenWidth - 8) / 2,
                                              y: (screenHeight - 8) / 2,
                                              width: 8,
                                              height: 8))
        centerDot.backgroundColor = .red
        centerDot.layer.cornerRadius = 4
        containerView.addSubview(centerDot)
        
        // Crosshair
        let crosshairSize: CGFloat = 25
        let horizontalLine = UIView(frame: CGRect(x: (screenWidth - crosshairSize) / 2,
                                                   y: (screenHeight - 1) / 2,
                                                   width: crosshairSize,
                                                   height: 1.5))
        horizontalLine.backgroundColor = .red
        containerView.addSubview(horizontalLine)
        
        let verticalLine = UIView(frame: CGRect(x: (screenWidth - 1) / 2,
                                                 y: (screenHeight - crosshairSize) / 2,
                                                 width: 1.5,
                                                 height: crosshairSize))
        verticalLine.backgroundColor = .red
        containerView.addSubview(verticalLine)
        
        // Label FOV
        let infoLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 120, height: 35))
        infoLabel.text = "FOV: 200"
        infoLabel.textColor = .red
        infoLabel.font = UIFont.boldSystemFont(ofSize: 13)
        infoLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 6
        infoLabel.clipsToBounds = true
        containerView.addSubview(infoLabel)
        
        fovOverlayWindow?.makeKeyAndVisible()
    }
    
    @objc func hideFOVOverlay() {
        fovOverlayWindow?.isHidden = true
        fovOverlayWindow = nil
        let alert = UIAlertController(title: "✅ Đã ẩn!", message: "Vòng FOV đã được ẩn!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UI HELPERS
    func createToggleRow(title: String, isOn: Bool) -> UIView {
        let row = UIView()
        row.backgroundColor = UIColor(white: 0.12, alpha: 1)
        row.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(label)
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.onTintColor = .red
        toggle.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 46),
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -15),
            toggle.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        ])
        
        return row
    }
    
    func createButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        return button
    }
}