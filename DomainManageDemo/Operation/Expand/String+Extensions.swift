//
//  String+Extensions.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import CommonCrypto
import UIKit

extension String {
    static func getAttributeStringWithString(_ string: String, lineSpace:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
        return attributedString
    }
    
    /// 否为空字符串
    var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    /// 字符串截取，从开始位置截取到第几位
    ///
    /// - Parameter index: 结束的位置
    /// - Returns: 返回截取后的字符串
    func substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从第几位开始截取
    ///
    /// - Parameter index: 从第几位开始截取
    /// - Returns: 返回截取后的字符串
    func substring(form index:Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从第几位到第几位开始截取
    ///
    /// - Parameters:
    ///   - startIndex: 开始截取的位置
    ///   - endIndex: 结束截取的位置
    /// - Returns: 返回截取后的字符串
    func substringWithStartforEnd(Start startIndex: Int, End endIndex:Int) -> String {
        if self.count > endIndex {
            let start = self.index(self.startIndex, offsetBy: startIndex)
            let end  = self.index(self.startIndex, offsetBy: endIndex)
            let subString = self[start..<end]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 字符串截取，从区间内截取
    ///
    /// - Parameters:
    ///   - startIndex: 开始截取的位置
    ///   - endIndex: 从字符串的尾数倒数回来的值
    /// - Returns: Returns: 返回截取后的字符串
    func substringWithRang(start startIndex : Int, end endIndex: Int) -> String {
        if self.count > endIndex {
            let start = self.index(self.startIndex, offsetBy: startIndex)
            let end  = self.index(self.endIndex, offsetBy: endIndex)
            let subString = self[start..<end]
            return String(subString)
        } else {
            return self
        }
    }
    
    //计算文字宽度
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - height  :高度
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_widthForComment(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    //计算文字高度
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - width   :宽度
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            
            hash.appendFormat("%02x", result[i])
            
        }
        
        return String(format: hash as String)
        
    }
    
    // 使用正则表达式替换
    func regularReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    // 加密 支付宝账号
    func encryptionZFBAccount() -> String {
        let theCount = self.length
        if theCount >= 2 {
            let oldStr = self
            if oldStr.contains("@") {
                return oldStr
            } else {
                var newStr = ""
                if theCount == 11 {
                    let start = 3
                    let mid = 4
                    let str_s = oldStr.substring(to: start )
                    let str_e = oldStr.substring(form: mid + start)
                    var str_m = ""
                    for _ in 1...mid {
                        str_m = str_m + "*"
                    }
                    newStr = str_s + str_m + str_e
                } else {
                    newStr = oldStr
                }
                return newStr
            }
        } else {
            return self
        }
    }
    
    // 加密 支付宝名称
    func encryptionZFBName() -> String {
        let theCount = self.length
        if theCount >= 2 {
            let oldStr = self
            var newStr = ""
            if theCount == 2 {
                let str_s = oldStr.substring(form: 1)
                newStr = "*\(str_s)"
            } else {
                let str_s = oldStr.substring(to: 1 )
                let str_e = oldStr.substring(form: theCount - 1)
                let mid = (theCount - 1) - 1
                var str_m = ""
                for _ in 1...mid {
                    str_m = str_m + "*"
                }
                newStr = "\(str_s)\(str_m)\(str_e)"
            }
            return newStr
        } else {
            return self
        }
    }
    
    func phoneEllipsis(_ ellip: Bool) {
        if self.count == 11 {
//            self.replaceSubrange(<#T##bounds: Range<String.Index>##Range<String.Index>#>, with: <#T##Collection#>)
        }
    }
    
    /// 给字符串添加横线
    func addHorizLine() -> NSMutableAttributedString {
        let attriDic = [NSAttributedString.Key.strikethroughStyle : NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)]
        let attr = NSMutableAttributedString(string: self, attributes: attriDic)
        return attr
    }
    
    
    /// 商品销量
    func salces() -> String {
        let count = Float(self) ?? 0.0
        if count > 10000 {
            let num = count / 10000
            return String(format: "%.1f万", num)
        }
        return self
    }
    
    /// 字符串转float
    /// - Parameter str: float字符串
    /// - Returns: float
    func strTransformFloat(str: String?) -> Float {
        return ceilf((Float(str ?? "0") ?? 0) * 100) / 100
    }
    
    func isEmptyStr() -> Bool {
        if self == nil {
            return true
        }
        if self.isEmpty {
            return true
        }
        if self.count == 0 {
            return true
        }
        if Float(self) == 0 {
            return true
        }
        return false
    }
}

extension URL {
    public var parametersFromQueryString : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
