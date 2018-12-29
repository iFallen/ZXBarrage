//
//  ViewController.swift
//  SwiftDanmuView
//
//  Created by liusilan on 2017/4/12.
//  Copyright © 2017年 silan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var danmuView: SLDanmuView = {
        var danmuView = SLDanmuView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: 200))
        return danmuView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var list = [SLDanmuInfo]()
        
        //test
        var info = SLDanmuInfo(text: "hi色黑龙江凡士林", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLDanmuInfo(text: "arre咳咳咳看", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLDanmuInfo(text: "fds分手快乐发送", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLDanmuInfo(text: "23诶偶无偶", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLDanmuInfo(text: "ff你好风刀霜剑反馈塑料袋交付的考四六级", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLDanmuInfo(text: "ff你好风刀霜剑发快递扩扩扩扩塑料袋交付的考四六级ff你好风刀霜剑发快递扩扩扩扩塑料袋交付的考四六级ff你好风刀霜剑发快递扩扩扩扩塑料袋交付的考四六级", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        info = SLBgDanmuInfo(text: "just for test", itemViewClass: SLDanmuBgItemView.self)
        list.append(info)
        
        for i in 0...10 {
            info = SLDanmuInfo(text: "考四六级" + String(i), itemViewClass: SLDanmuBgItemView.self)
            list.append(info)
        }
        
        danmuView.pendingList.append(contentsOf: list)

        self.view.addSubview(danmuView)
        
        self.view.backgroundColor = UIColor(red: 228 / 255.0, green: 238 / 255.0, blue: 251 / 255.0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        danmuView.pause()
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        danmuView.resume()
    }
}

