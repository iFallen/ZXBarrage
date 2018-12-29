//
//  SLDanmuView.swift
//  SwiftDanmuView
//
//  Created by liusilan on 2017/4/12.
//  Copyright © 2017年 silan. All rights reserved.
//

import Foundation
import UIKit

class SLDanmuView: UIView {
    // 轨道间距
    let lineSpace: CGFloat = 60
    
    // 轨道数
    var numberOfRows: Int = 3
    
    var speed: CGFloat = 75.0
    
    var timer: Timer?
    
    lazy var pendingList: [SLDanmuInfo] = {
        var list = Array<SLDanmuInfo>()
        
        return list
    }()
    
    lazy var reuseItemViewSet: Set<UIView> = {
        var set = Set<UIView>()
        return set
    }()
    
    // key:className
    lazy var reuseItemViewPool: [String: UIView] = {
        var reusePool = [String: UIView]()
        return reusePool
    }()
    
    // 最后一条弹幕完全显示在屏幕上的时间记录
    lazy var timeDict: [Int: CGFloat] = {
        var dict = [Int: CGFloat]()
        return dict
    }()
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        commonInit()
    }
    
    func commonInit() {
        startTimer()
    }
    
    
    //MARK: timer
    func startTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(SLDanmuView.handleTimer), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func handleTimer() {
        guard pendingList.count > 0 else {
            return
        }
        
        if let info = pendingList.first {
            playDanmu(info: info)
            pendingList.remove(at: 0)
        }
    }
    
    //MARK:play danmu
    func rowHeight() -> CGFloat {
        return (self.frame.size.height - lineSpace * CGFloat((numberOfRows - 1))) / CGFloat(numberOfRows)
    }
    
    func rowWithY(y: CGFloat) -> Int {
        return Int(y / (rowHeight() + lineSpace))
    }
    
    func reuseItemView(cls: AnyClass) -> UIView? {
        guard reuseItemViewPool.count > 0 else {
            return nil
        }
        
        let className = NSStringFromClass(cls)
        if let reuseView = reuseItemViewPool[className] {
            reuseItemViewPool.removeValue(forKey: className)
            //print("reuseItemView: \(reuseView)")
            //print("reusePool:\(self.reuseItemViewPool)")
            
            return reuseView
        }
        
        return nil
    }
    
    // 计算弹轨
    func calculateRow() -> Int {
        for index in 0..<numberOfRows {
            // 判断是否能放在该条轨道，即该轨道的最后一条弹幕已经在屏幕上。
            var shouldShow = true
            if let time = timeDict[index] {
                let currentTime = NSDate()
                if currentTime.timeIntervalSince1970 < TimeInterval(time) {
                    shouldShow = false
                }
            }
            
            if shouldShow {
                return index
            }
        }
        
        return -1;
    }
    
    // 播放弹幕
    func playDanmu(info: SLDanmuInfo) {
        guard info.text.count > 0 else {
            return
        }
        
        // 计算弹轨
        let index = calculateRow()
        guard index >= 0 && index < numberOfRows else {
            pendingList.insert(info, at: 0)
            return
        }
        
        let itemViewClass: AnyClass = info.itemViewClass
        var reuseItemView = self.reuseItemView(cls: itemViewClass)
        if reuseItemView == nil {
            if let cls = itemViewClass as? UIView.Type {
                reuseItemView = cls.init()
            }
        }
        
        guard let itemView = reuseItemView else {
            pendingList.insert(info, at: 0)
            return
        }
        
        // 计算坐标y
        let y =  CGFloat(index) * (lineSpace + rowHeight())
        
        var zxframe = itemView.frame
        zxframe.origin.x = self.frame.size.width //+ CGFloat(index) * 100
        zxframe.origin.y = y
        itemView.frame = zxframe
        
        
        if let itemView = itemView as? SLDanmuItemView {
            itemView.updateDanmuInfo(info: info)
        }
        
        itemView.sizeToFit()
        
        self.addSubview(itemView)
        
        // 弹幕完全显示在屏幕的时间+间隔
//<<<<<<< .mine
//        var speed: CGFloat = 75.0
//        if index == 1 {
//            speed = 85
//        } else if index == 2 {
//            speed = 70
//        }
//        let time = itemView.frame.size.width / speed + 0.5 + CGFloat(NSDate().timeIntervalSince1970)
//=======
        let time = itemView.frame.size.width / speed + 3 + CGFloat(NSDate().timeIntervalSince1970)
        timeDict[index] = time
        
        // 动画
        let duration = (self.frame.size.width + itemView.frame.size.width) / speed
        itemView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(Double(index) * 4)) {
            itemView.isHidden = false
        }
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(Double(index) * 4), options: .curveLinear, animations: {
            var zxframe = itemView.frame
            zxframe.origin.x = -zxframe.size.width
            itemView.frame = zxframe
            
        }) { (finished) in
            if (finished) {
                // add to reusePool
                self.reuseItemViewPool[NSStringFromClass(itemViewClass)] = itemView
                //print("reusePool:\(self.reuseItemViewPool)")
                itemView.removeFromSuperview()
            }
        }
    }
    
    func pause() {
        stopTimer()
        
        for itemView in self.subviews {
            if itemView.isKind(of: SLDanmuItemView.self) {
                if let frame = itemView.layer.presentation()?.frame {
                    itemView.frame = frame
                }
                
                itemView.layer.removeAllAnimations()
            }
        }
    }
    
    func resume() {
        startTimer()
        
        for itemView in self.subviews {
            if itemView.isKind(of: SLDanmuItemView.self) {
                let index = rowWithY(y: itemView.frame.origin.y)
                
                // 更新时间，如果右边未完全显示在屏幕
                var speed: CGFloat = 75.0
                if index == 1 {
                    speed = 85
                } else if index == 2 {
                    speed = 70
                }
                if (itemView.frame.origin.x + itemView.frame.size.width > self.frame.size.width) {
                    let time = (itemView.frame.origin.x + itemView.frame.size.width - self.frame.size.width) / speed + 0.5 + CGFloat(NSDate().timeIntervalSince1970)
                    timeDict[index] = time
                }
                
                let duration = (itemView.frame.origin.x + itemView.frame.size.width) / speed
                
                UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveLinear, animations: {
                    var zxframe = itemView.frame
                    zxframe.origin.x = -zxframe.size.width
                    itemView.frame = zxframe
                    
                }) { (finished) in
                    if (finished) {
                        let mirror = Mirror(reflecting: itemView)
                        self.reuseItemViewPool[NSStringFromClass(mirror.subjectType as! AnyClass)] = itemView
                        itemView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func reset() {
        stopTimer()
        
        reuseItemViewSet.removeAll()
        pendingList.removeAll()
        timeDict.removeAll()
    }
}
