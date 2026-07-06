//
//  RootViewController.swift
//  FFMMEext - Free Fire Menu Hack OB54
//  Tweak iOS cho Free Fire phiên bản OB54
//  Build với Theos trên iSH hoặc macOS
//

import UIKit
import Foundation

// ============================================
// MARK: - CẤU HÌNH TOÀN CỤC
// ============================================
let MENU_TITLE = "TuanAnhCodeX"
let MENU_VERSION = "OB54"
let ADMIN_ZALO = "0339651811"

// ============================================
// MARK: - HOOK UNITY ENGINE
// ============================================

// Hook hàm get_field_of_view để mở rộng tầm nhìn (Aim FOV)
@_cdecl("hook_get_fov")
func hookGetFOV() -> Float {
    // FOV gốc: 60.0 -> mở rộng lên 120.0
    return 120.0
}

// Hook hàm get_recoil để giảm độ giật (No Recoil)
@_cdecl("hook_get_recoil")
func hookGetRecoil() -> Float {
    // Recoil gốc: 1.0 -> giảm về 0.0
    return 0.0
}

// Hook hàm get_spread để giảm độ tản (No Spread)
@_cdecl("hook_get_spread")
func hookGetSpread() -> Float {
    // Spread gốc: 1.0 -> giảm về 0.0
    return 0.0
}

// Hook hàm is_visible để soi tường (Wallhack)
@_cdecl("hook_is_visible")
func hookIsVisible() -> Bool {
    // Luôn trả về true -> nhìn xuyên tường
    return true
}

// Hook hàm get_speed để tăng tốc (Speed Hack)
@_cdecl("hook_get_speed")
func hookGetSpeed() -> Float {
    // Speed gốc: 1.0 -> tăng lên 3.0
    return 3.0
}

// Hook hàm get_damage để one-shot (Damage Multiplier)
@_cdecl("hook_get_damage")
func hookGetDamage() -> Float {
    // Damage gốc: 1.0 -> tăng lên 100.0
    return 100.0
}

// Hook hàm get_health để bất tử (God Mode)
@_cdecl("hook_get_health")
func hookGetHealth() -> Float {
    // Health luôn max
    return 9999.0
}

// Hook hàm is_aimbot_enabled để auto aim
@_cdecl("hook_aimbot")
func hookAimbot() -> Bool {
    return true
}

// Hook hàm get_aim_smooth để aim mượt
@_cdecl("hook_aim_smooth")
func hookAimSmooth() -> Float {
    // 0.0 = instant lock, 0.5 = smooth
    return 0.1
}

// Hook hàm get_esp_color để hiển thị màu sắc ESP
@_cdecl("hook_esp_color")
func hookESPColor(team: Int32) -> UnsafePointer<Float> {
    // Team 0 = enemy (red), Team 1 = ally (green)
    let enemyColor: [Float] = [1.0, 0.0, 0.0, 1.0]  // RGBA Red
    let allyColor: [Float] = [0.0, 1.0, 0.0, 1.0]   // RGBA Green
    // Trả về pointer tới mảng màu
    return team == 0 ? UnsafePointer(enemyColor) : UnsafePointer(allyColor)
}

// ============================================
// MARK: - MENU UI OVERLAY
// ============================================

class HackMenuViewController: UIViewController {
    
    var menuView: UIView!
    var isMenuVisible = false
    var hackToggles: [String: UISwitch] = [:]
    
    // Trạng thái các chức năng hack
    var hackStates: [String: Bool] = [
        "aimbot": false,
        "wallhack": false,
        "norecoil": false,
        "nospread": false,
        "speedhack": false,
        "godmode": false,
        "fov": false,
        "esp": false,
        "fastreload": false,
        "antiban": false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingButton()
        setupMenu()
    }
    
    // Nút floating để mở menu
    func setupFloatingButton() {
        let floatBtn = UIButton(type: .system)
        floatBtn.frame = CGRect(x: 20, y: 100, width: 60, height: 60)
        floatBtn.backgroundColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 0.9)
        floatBtn.layer.cornerRadius = 30
        floatBtn.layer.borderWidth = 2
        floatBtn.layer.borderColor = UIColor.white.cgColor
        floatBtn.setTitle("⚡", for: .normal)
        floatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        floatBtn.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        floatBtn.tag = 9999
        
        // Make draggable
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragButton(_:)))
        floatBtn.addGestureRecognizer(panGesture)
        
        view.addSubview(floatBtn)
    }
    
    @objc func dragButton(_ gesture: UIPanGestureRecognizer) {
        let button = gesture.view!
        let translation = gesture.translation(in: view)
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    // Setup menu chính
    func setupMenu() {
        menuView = UIView(frame: CGRect(x: 50, y: 150, width: 280, height: 500))
        menuView.backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.08, alpha: 0.95)
        menuView.layer.cornerRadius = 15
        menuView.layer.borderWidth = 1
        menuView.layer.borderColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0).cgColor
        menuView.isHidden = true
        
        // Header
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        header.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 30))
        titleLabel.text = "\(MENU_TITLE) v\(MENU_VERSION)"
        titleLabel.textColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        header.addSubview(titleLabel)
        
        let closeBtn = UIButton(type: .system)
        closeBtn.frame = CGRect(x: 240, y: 10, width: 30, height: 30)
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        header.addSubview(closeBtn)
        
        menuView.addSubview(header)
        
        // Scroll view cho các toggle
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: 280, height: 380))
        
        let hacks = [
            ("aimbot", "🎯 AIMBOT"),
            ("wallhack", "👁 WALLHACK"),
            ("norecoil", "🔫 NO RECOIL"),
            ("nospread", "🎯 NO SPREAD"),
            ("speedhack", "⚡ SPEED HACK"),
            ("godmode", "🛡 GOD MODE"),
            ("fov", "👁 WIDE FOV"),
            ("esp", "📡 ESP"),
            ("fastreload", "⚡ FAST RELOAD"),
            ("antiban", "🛡 ANTI-BAN")
        ]
        
        var yOffset: CGFloat = 10
        for (key, label) in hacks {
            let row = createHackRow(key: key, label: label, y: yOffset)
            scrollView.addSubview(row)
            yOffset += 45
        }
        
        scrollView.contentSize = CGSize(width: 280, height: yOffset)
        menuView.addSubview(scrollView)
        
        // Footer - Contact info
        let footer = UIView(frame: CGRect(x: 0, y: 440, width: 280, height: 60))
        footer.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.1, alpha: 1.0)
        
        let contactLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 260, height: 20))
        contactLabel.text = "📞 Liên hệ Admin mua key"
        contactLabel.textColor = .lightGray
        contactLabel.font = UIFont.systemFont(ofSize: 11)
        contactLabel.textAlignment = .center
        footer.addSubview(contactLabel)
        
        let zaloLabel = UILabel(frame: CGRect(x: 10, y: 25, width: 260, height: 25))
        zaloLabel.text = "Zalo: \(ADMIN_ZALO)"
        zaloLabel.textColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
        zaloLabel.font = UIFont.boldSystemFont(ofSize: 14)
        zaloLabel.textAlignment = .center
        footer.addSubview(zaloLabel)
        
        menuView.addSubview(footer)
        
        // Make menu draggable
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragMenu(_:)))
        header.addGestureRecognizer(panGesture)
        
        view.addSubview(menuView)
    }
    
    func createHackRow(key: String, label: String, y: CGFloat) -> UIView {
        let row = UIView(frame: CGRect(x: 10, y: y, width: 260, height: 40))
        
        let labelView = UILabel(frame: CGRect(x: 0, y: 5, width: 180, height: 30))
        labelView.text = label
        labelView.textColor = .white
        labelView.font = UIFont.systemFont(ofSize: 14)
        row.addSubview(labelView)
        
        let toggle = UISwitch(frame: CGRect(x: 200, y: 5, width: 51, height: 31))
        toggle.onTintColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
        toggle.tag = key.hashValue
        toggle.addTarget(self, action: #selector(toggleHack(_:)), for: .valueChanged)
        row.addSubview(toggle)
        
        hackToggles[key] = toggle
        
        return row
    }
    
    @objc func toggleHack(_ sender: UISwitch) {
        for (key, toggle) in hackToggles {
            if toggle == sender {
                hackStates[key] = sender.isOn
                print("[\(MENU_TITLE)] \(key): \(sender.isOn ? "ON" : "OFF")")
                
                // Áp dụng hack vào memory
                applyHack(key: key, enabled: sender.isOn)
                break
            }
        }
    }
    
    func applyHack(key: String, enabled: Bool) {
        // Gọi C function để patch memory
        switch key {
        case "aimbot":
            patchMemory(offset: 0x2A4B80, bytes: enabled ? [0x01, 0x00, 0x00, 0xD4] : [0x00, 0x00, 0x00, 0xD4])
        case "wallhack":
            patchMemory(offset: 0x3C1F20, bytes: enabled ? [0x20, 0x00, 0x80, 0xD2] : [0x00, 0x00, 0x00, 0xD4])
        case "norecoil":
            patchMemory(offset: 0x1E8A40, bytes: enabled ? [0x00, 0x00, 0x00, 0x00] : [0x1F, 0x20, 0x03, 0xD5])
        case "nospread":
            patchMemory(offset: 0x1E8B60, bytes: enabled ? [0x00, 0x00, 0x00, 0x00] : [0x1F, 0x20, 0x03, 0xD5])
        case "speedhack":
            patchMemory(offset: 0x2F5C00, bytes: enabled ? [0x00, 0x00, 0x70, 0x42] : [0x00, 0x00, 0x80, 0x3F])
        case "godmode":
            patchMemory(offset: 0x1A3D80, bytes: enabled ? [0xFF, 0xFF, 0x7F, 0x7F] : [0x00, 0x00, 0x80, 0x42])
        case "fov":
            patchMemory(offset: 0x2A1E00, bytes: enabled ? [0x00, 0x00, 0xF0, 0x42] : [0x00, 0x00, 0x70, 0x42])
        case "esp":
            patchMemory(offset: 0x3D8A00, bytes: enabled ? [0x01, 0x00, 0x00, 0xD4] : [0x00, 0x00, 0x00, 0xD4])
        case "fastreload":
            patchMemory(offset: 0x1F2C80, bytes: enabled ? [0x00, 0x00, 0x00, 0x00] : [0x1F, 0x20, 0x03, 0xD5])
        case "antiban":
            patchMemory(offset: 0x4A5E00, bytes: enabled ? [0x00, 0x00, 0x00, 0xD4] : [0x1F, 0x20, 0x03, 0xD5])
        default:
            break
        }
    }
    
    // Hàm patch memory trực tiếp
    func patchMemory(offset: UInt64, bytes: [UInt8]) {
        // Sử dụng MSHookFunction hoặc substrate để patch
        let baseAddr = getBaseAddress()
        let targetAddr = baseAddr + offset
        
        // Make memory writable
        mprotect(UnsafeMutableRawPointer(bitPattern: UInt(targetAddr & ~0x3FFF)), 0x4000, PROT_READ | PROT_WRITE | PROT_EXEC)
        
        // Write bytes
        let ptr = UnsafeMutablePointer<UInt8>(bitPattern: UInt(targetAddr))
        for (i, byte) in bytes.enumerated() {
            ptr?.advanced(by: i).pointee = byte
        }
        
        // Flush cache
        __builtin___clear_cache(UnsafeMutableRawPointer(bitPattern: UInt(targetAddr)), UnsafeMutableRawPointer(bitPattern: UInt(targetAddr + UInt64(bytes.count))))
    }
    
    func getBaseAddress() -> UInt64 {
        // Lấy base address của Free Fire binary
        var info = dl_info()
        dladdr(dlsym(UnsafeMutableRawPointer(bitPattern: 1), "_mh_execute_header"), &info)
        return UInt64(bitPattern: info.dli_fbase)
    }
    
    @objc func toggleMenu() {
        isMenuVisible = !isMenuVisible
        menuView.isHidden = !isMenuVisible
    }
    
    @objc func dragMenu(_ gesture: UIPanGestureRecognizer) {
        let menu = gesture.view!.superview!
        let translation = gesture.translation(in: view)
        menu.center = CGPoint(x: menu.center.x + translation.x, y: menu.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
}

// ============================================
// MARK: - TWEAK ENTRY POINT
// ============================================

class FFMMEext: NSObject {
    static let shared = FFMMEext()
    var menuVC: HackMenuViewController?
    
    @objc func initTweak() {
        print("[\(MENU_TITLE)] Tweak loaded successfully!")
        
        // Tạo overlay window
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showMenu()
        }
    }
    
    func showMenu() {
        let window = UIApplication.shared.keyWindow
        menuVC = HackMenuViewController()
        menuVC?.view.frame = UIScreen.main.bounds
        window?.addSubview(menuVC!.view)
    }
}

// Constructor - tự động chạy khi tweak load
@_cdecl("ctor")
func ctor() {
    FFMMEext.shared.initTweak()
}
