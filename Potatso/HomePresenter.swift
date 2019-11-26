//
//  HomePresenter.swift
//  Potatso
//
//  Created by LEI on 6/22/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol: class {
    func handleRefreshUI()
}

class HomePresenter: NSObject {

    var vc: UIViewController!

    var group: ConfigurationGroup {
        return CurrentGroupManager.shared.group
    }

    var proxy: Proxy? {
        return group.proxies.first
    }

    weak var delegate: HomePresenterProtocol?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged), name: NSNotification.Name(rawValue: kProxyServiceVPNStatusNotification), object: nil)
        CurrentGroupManager.shared.onChange = { group in
            self.delegate?.handleRefreshUI()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func bindToVC(_ vc: UIViewController) {
        self.vc = vc
    }

    // MARK: - Actions

    func switchVPN() {
        VPN.switchVPN(group) { [unowned self] (error) in
            if let error = error {
                Alert.show(self.vc, message: "\("Fail to switch VPN.".localized()) (\(error))")
            }
        }
    }
    
    func Seven_SwitchVPN(completion: ((Error?) -> Void)? = nil) {
        VPN.switchVPN(group, completion: completion)
    }

    func chooseProxy() {
        NSLog("self.proxy = %@", proxy ?? "null proxy")
        
        let chooseVC = ProxyListViewController(allowNone: true) { [unowned self] proxy in
            do {
                NSLog("proxy22222 = %@", proxy ?? "null proxy")

                try ConfigurationGroup.changeProxy(forGroupId: self.group.uuid, proxyId: proxy?.uuid)
                self.delegate?.handleRefreshUI()
            }catch {
                self.vc.showTextHUD("\("Fail to change proxy".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
            }
        }
        vc.navigationController?.pushViewController(chooseVC, animated: true)
    }
    
    func Seven_StartVPN() {
        Manager.sharedManager.startVPN()
    }
    
    func Seven_StopVPN() {
        Manager.sharedManager.stopVPN()
    }
    
    /// 切换节点
    ///
    /// - Parameter proxyId: 节点 ID
    func Seven_choose_Proxy(proxyId: String) {
        do {
            try ConfigurationGroup.changeProxy(forGroupId: self.group.uuid, proxyId: proxyId)
        }catch {
            let alert = UIAlertController(title: "切换节点失败", message: nil, preferredStyle: .alert)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 获取本地节点数组
    ///
    /// - Returns: 本地节点数组
    func Seven_fetchLocalProxies() -> [Proxy] {
        return DBUtils.allNotDeleted(Proxy.self, sorted: "createAt").map({ $0 })
    }
    
    /// 获取本地规则集
    ///
    /// - Returns: 本地规则集
    func Seven_fetchLocalRuleSet() -> RuleSet? {
        let ruleset = DBUtils.allNotDeleted(RuleSet.self, sorted: "createAt").map({ $0 }).first
        return ruleset;
    }
    
    func Seven_deleteLocalRuleSet() {
        var proxyIDs:[String] = []
        let ruleSets = DBUtils.allNotDeleted(RuleSet.self, sorted: "createAt").map({ $0 })
        for ruleSet in ruleSets {
            proxyIDs.append(ruleSet.uuid)
        }
        
        do {
            try DBUtils.hardDelete(proxyIDs, type: RuleSet.self)
        } catch {
        }
    }
    
    
    /// 判断 VPN 是否开启。原来的状态有 4 种，但是 UI 上只体现了两种。中间做个转换
    ///
    /// - Returns: VPN 是否开启
    func Seven_isVpnOn() -> Bool {
        var status: VPNStatus
        if group.isDefault {
            status = Manager.sharedManager.vpnStatus
        }else {
            status = .off
        }
        switch status {
            case .off:
                return false
            case .connecting:
                return false
            case .on:
                return true
            case .disconnecting:
                return false
        }
    }
    
    func Seven_deleteProxies(proxies: [Proxy]) {
        var proxyIDs:[String] = []
        
        for proxy in proxies {
            proxyIDs.append(proxy.uuid)
        }
        
        do {
            try DBUtils.hardDelete(proxyIDs, type: Proxy.self)
        } catch {
        }
    }
    
    // 保存的是写死的节点
    func Seven_saveFakeProxy(_ip : String, _port : Int, _cipherMode : String, _key : String) {
        do {
            let upstreamProxy: Proxy = Proxy()
            upstreamProxy.type = .Shadowsocks
            upstreamProxy.name = "default proxy"
            //            upstreamProxy.host = "52.175.26.57"
            //            upstreamProxy.port = 20000
            //            upstreamProxy.authscheme = "aes-256-cfb"
            //            upstreamProxy.user = nil
            //            upstreamProxy.password = "ss.7xNetworks@C0M"
//            upstreamProxy.host = "47.52.93.214"
//            upstreamProxy.port = 8989
//            upstreamProxy.authscheme = "aes-256-cfb"
//            upstreamProxy.user = nil
//            upstreamProxy.password = "teddysun.com"
            
            upstreamProxy.host = _ip
            upstreamProxy.port = _port
            upstreamProxy.authscheme = _cipherMode
            upstreamProxy.user = nil
            upstreamProxy.password = _key
            
            
            upstreamProxy.ota = false
            upstreamProxy.ssrProtocol = ""
            upstreamProxy.ssrObfs = ""
            upstreamProxy.ssrObfsParam = ""
            try DBUtils.add(upstreamProxy)
        }catch {
        }
    }

    
    /// 保存规则集
    func Seven_saveFakeRuleSet() {
        let ruleSet = RuleSet()
        ruleSet.name = "Default"
        
        /// 添加一条百度直连的规则。可以通过百度搜 ip 验证。
        let rule = Rule(type: .GeoIP, action: .Direct, value: "CN")
        let rule1 = Rule(type: .DomainMatch, action: .Proxy, value: "google")
        let rule2 = Rule(type: .DomainMatch, action: .Proxy, value: "facebook")
        let rule3 = Rule(type: .DomainMatch, action: .Proxy, value: "youtube")
        let rule4 = Rule(type: .DomainMatch, action: .Proxy, value: "twitter")
        let rule5 = Rule(type: .DomainMatch, action: .Proxy, value: "instagram")
        let rule6 = Rule(type: .DomainMatch, action: .Proxy, value: "gmail")
        let rule7 = Rule(type: .DomainSuffix, action: .Proxy, value: "twimg.com")
        let rule8 = Rule(type: .DomainSuffix, action: .Proxy, value: "t.co")
        let rule9 = Rule(type: .DomainSuffix, action: .Proxy, value: "kenengba.com")
        let rule10 = Rule(type: .DomainSuffix, action: .Proxy, value: "akamai.net")
        let rule11 = Rule(type: .DomainSuffix, action: .Direct, value: "apple.com")
        let rule12 = Rule(type: .DomainSuffix, action: .Proxy, value: "mzstatic.com")
        let rule13 = Rule(type: .DomainSuffix, action: .Proxy, value: "itunes.com")
        let rule14 = Rule(type: .DomainSuffix, action: .Direct, value: "icloud.com")
        let rule15 = Rule(type: .DomainSuffix, action: .Direct, value: "lcdn-registration.apple.com")
        let rule16 = Rule(type: .DomainMatch, action: .Reject, value: "umeng.co")
        let rule17 = Rule(type: .DomainMatch, action: .Reject, value: "flurry.co")
        let rule18 = Rule(type: .DomainSuffix, action: .Reject, value: "mmstat.com")
        let rule19 = Rule(type: .DomainSuffix, action: .Reject, value: "doubleclick.net")
        let rule20 = Rule(type: .Domain, action: .Reject, value: "bam.nr-data.net")
        let rule21 = Rule(type: .Domain, action: .Reject, value: "counter.kingsoft.com")
        let rule22 = Rule(type: .Domain, action: .Reject, value: "js-agent.newrelic.com")
        let rule23 = Rule(type: .Domain, action: .Reject, value: "pixel.wp.com")
        let rule24 = Rule(type: .Domain, action: .Reject, value: "stat.m.jd.com")
        let rule25 = Rule(type: .DomainSuffix, action: .Reject, value: "51.la")
        let rule26 = Rule(type: .DomainSuffix, action: .Reject, value: "adjust.com")
        let rule27 = Rule(type: .DomainSuffix, action: .Reject, value: "cmcore.com")
        let rule28 = Rule(type: .DomainSuffix, action: .Reject, value: "coremetrics.com")
        let rule29 = Rule(type: .DomainSuffix, action: .Reject, value: "cnzz.com")
        let rule30 = Rule(type: .DomainSuffix, action: .Reject, value: "flurry.com")
        let rule31 = Rule(type: .DomainSuffix, action: .Reject, value: "irs01.com")
        let rule32 = Rule(type: .DomainSuffix, action: .Reject, value: "madmini.com")
        let rule33 = Rule(type: .DomainSuffix, action: .Reject, value: "mixpanel.com")
        let rule34 = Rule(type: .DomainSuffix, action: .Reject, value: "mmstat.com")
        let rule35 = Rule(type: .DomainSuffix, action: .Reject, value: "wrating.com")
        let rule36 = Rule(type: .DomainMatch, action: .Reject, value: "ads")
        let rule37 = Rule(type: .DomainMatch, action: .Reject, value: "analytics")
        let rule38 = Rule(type: .DomainMatch, action: .Reject, value: "duomeng")
        let rule39 = Rule(type: .DomainMatch, action: .Reject, value: "track")
        let rule40 = Rule(type: .DomainMatch, action: .Reject, value: "traffic")
        let rule41 = Rule(type: .DomainMatch, action: .Reject, value: "adsmogo")
        let rule42 = Rule(type: .DomainSuffix, action: .Reject, value: "admaster.com.cn")
        let rule43 = Rule(type: .DomainSuffix, action: .Reject, value: "51.la")
        let rule44 = Rule(type: .DomainSuffix, action: .Reject, value: "acs86.com")
        let rule45 = Rule(type: .DomainSuffix, action: .Reject, value: "adchina.com")
        let rule46 = Rule(type: .DomainSuffix, action: .Reject, value: "adcome.cn")
        let rule47 = Rule(type: .DomainSuffix, action: .Reject, value: "adinfuse.com")
        let rule48 = Rule(type: .DomainSuffix, action: .Reject, value: "admob.com")
        let rule49 = Rule(type: .DomainSuffix, action: .Reject, value: "adsage.cn")
        let rule50 = Rule(type: .DomainSuffix, action: .Reject, value: "adsage.com")
        let rule51 = Rule(type: .DomainSuffix, action: .Reject, value: "adsmogo.org")
        let rule52 = Rule(type: .DomainSuffix, action: .Reject, value: "ads.mobclix.com")
        let rule53 = Rule(type: .DomainSuffix, action: .Reject, value: "adview.cn")
        let rule54 = Rule(type: .DomainSuffix, action: .Reject, value: "adwhirl.com")
        let rule55 = Rule(type: .DomainSuffix, action: .Reject, value: "adwo.com")
        let rule56 = Rule(type: .DomainSuffix, action: .Reject, value: "ad.unimhk.com")
        let rule57 = Rule(type: .DomainSuffix, action: .Reject, value: "aduu.cn")
        let rule58 = Rule(type: .DomainSuffix, action: .Reject, value: "advertising.com")
        let rule59 = Rule(type: .DomainSuffix, action: .Reject, value: "adview.cn")
        let rule60 = Rule(type: .DomainSuffix, action: .Reject, value: "adwhirl.com")
        let rule61 = Rule(type: .DomainSuffix, action: .Reject, value: "adwo.com")
        let rule62 = Rule(type: .DomainSuffix, action: .Reject, value: "adxmi.com")
        let rule63 = Rule(type: .DomainSuffix, action: .Reject, value: "adzerk.net")
        let rule64 = Rule(type: .DomainSuffix, action: .Reject, value: "anquan.org")
        let rule65 = Rule(type: .DomainSuffix, action: .Reject, value: "appads.com")
        let rule66 = Rule(type: .DomainSuffix, action: .Reject, value: "applifier.com")
        let rule67 = Rule(type: .DomainSuffix, action: .Reject, value: "appsflyer.com")
        let rule68 = Rule(type: .DomainSuffix, action: .Reject, value: "baidustatic.com")
        let rule69 = Rule(type: .DomainSuffix, action: .Reject, value: "baifendian.com")
        let rule70 = Rule(type: .DomainSuffix, action: .Reject, value: "bam.nr-data.net")
        let rule71 = Rule(type: .DomainSuffix, action: .Reject, value: "beacon.sina.com.cn")
        let rule72 = Rule(type: .DomainSuffix, action: .Reject, value: "cnzz.com")
        let rule73 = Rule(type: .DomainSuffix, action: .Reject, value: "domob.com.cn")
        let rule74 = Rule(type: .DomainSuffix, action: .Reject, value: "domob.org")
        let rule75 = Rule(type: .DomainSuffix, action: .Reject, value: "doubleclick.net")
        let rule76 = Rule(type: .DomainSuffix, action: .Reject, value: "duomeng.cn")
        let rule77 = Rule(type: .DomainSuffix, action: .Reject, value: "duomeng.net")
        let rule78 = Rule(type: .DomainSuffix, action: .Reject, value: "duomeng.org")
        let rule79 = Rule(type: .DomainSuffix, action: .Reject, value: "flurry.com")
        let rule80 = Rule(type: .DomainSuffix, action: .Reject, value: "googeadsserving.cn")
        let rule81 = Rule(type: .DomainSuffix, action: .Reject, value: "guomob.com")
        let rule82 = Rule(type: .DomainSuffix, action: .Reject, value: "inmobi.com")
        let rule83 = Rule(type: .DomainSuffix, action: .Reject, value: "immob.cn")
        let rule84 = Rule(type: .DomainSuffix, action: .Reject, value: "intely.cn")
        let rule85 = Rule(type: .DomainSuffix, action: .Reject, value: "kejet.net")
        let rule86 = Rule(type: .DomainSuffix, action: .Reject, value: "localytics.com")
        let rule87 = Rule(type: .DomainSuffix, action: .Reject, value: "mobads.baidu.com")
        let rule88 = Rule(type: .DomainSuffix, action: .Reject, value: "mobads-logs.baidu.com")
        let rule89 = Rule(type: .DomainSuffix, action: .Reject, value: "smartadserver.com")
        let rule90 = Rule(type: .DomainSuffix, action: .Reject, value: "tapjoyads.com")
        let rule91 = Rule(type: .DomainSuffix, action: .Reject, value: "m.simaba.taobao.com")
        let rule92 = Rule(type: .DomainSuffix, action: .Reject, value: "mmstat.com")
        let rule93 = Rule(type: .DomainSuffix, action: .Reject, value: "sax.sina.cn")
        let rule94 = Rule(type: .DomainSuffix, action: .Reject, value: "tanx.com")
        let rule95 = Rule(type: .DomainSuffix, action: .Reject, value: "tapjoyads.com")
        let rule96 = Rule(type: .DomainSuffix, action: .Reject, value: "tiqcdn.com")
        let rule97 = Rule(type: .DomainSuffix, action: .Reject, value: "umtrack.com")
        let rule98 = Rule(type: .DomainSuffix, action: .Reject, value: "umeng.co")
        let rule99 = Rule(type: .DomainSuffix, action: .Reject, value: "umeng.com")
        let rule100 = Rule(type: .DomainSuffix, action: .Reject, value: "umeng.net")
        let rule101 = Rule(type: .DomainSuffix, action: .Reject, value: "ushaqi.com")
        let rule102 = Rule(type: .DomainSuffix, action: .Reject, value: "uyunad.com")
        let rule103 = Rule(type: .DomainSuffix, action: .Reject, value: "waps.cn")
        let rule104 = Rule(type: .DomainSuffix, action: .Reject, value: "wiyun.com")
        let rule105 = Rule(type: .DomainSuffix, action: .Reject, value: "wooboo.com.cn")
        let rule106 = Rule(type: .DomainSuffix, action: .Reject, value: "wqmobile.com")
        let rule107 = Rule(type: .DomainSuffix, action: .Reject, value: "x.jd.com")
        let rule108 = Rule(type: .DomainSuffix, action: .Reject, value: "youmi.net")
        let rule109 = Rule(type: .DomainSuffix, action: .Reject, value: "zhiziyun.com")
        let rule110 = Rule(type: .DomainSuffix, action: .Reject, value: "data.vod.itc.cn")
        let rule111 = Rule(type: .DomainSuffix, action: .Reject, value: "atm.youku.com")
        let rule112 = Rule(type: .Domain, action: .Reject, value: "ad.api.3g.youku.com")
        let rule113 = Rule(type: .Domain, action: .Reject, value: "ad.api.3g.tudou.com")
        let rule114 = Rule(type: .Domain, action: .Reject, value: "monitor.uu.qq.com")
        let rule115 = Rule(type: .Domain, action: .Reject, value: "pingjs.qq.com")
        let rule116 = Rule(type: .Domain, action: .Reject, value: "pingma.qq.com")
        let rule117 = Rule(type: .Domain, action: .Reject, value: "tajs.qq.com")
        let rule118 = Rule(type: .DomainSuffix, action: .Reject, value: "pingtcss.qq.com")
        let rule119 = Rule(type: .DomainSuffix, action: .Reject, value: "report.qq.com")
        let rule120 = Rule(type: .Domain, action: .Reject, value: "mi.gdt.qq.com")
        let rule121 = Rule(type: .Domain, action: .Reject, value: "dsp.youdao.com")
        let rule122 = Rule(type: .Domain, action: .Reject, value: "g.163.com")
        let rule123 = Rule(type: .Domain, action: .Reject, value: "temp.163.com")
        let rule124 = Rule(type: .DomainSuffix, action: .Reject, value: "stat.ws.126.net")
        let rule125 = Rule(type: .DomainSuffix, action: .Reject, value: "analytics.126.net")
        let rule126 = Rule(type: .DomainSuffix, action: .Reject, value: "union.youdao.com")
        let rule127 = Rule(type: .Domain, action: .Reject, value: "msga.71.am")
        let rule128 = Rule(type: .DomainSuffix, action: .Reject, value: "miaozhen.com")
        let rule129 = Rule(type: .Domain, action: .Reject, value: "cr-nielsen.com")
        let rule130 = Rule(type: .Domain, action: .Reject, value: "cbjs.baidu.com")
        let rule131 = Rule(type: .Domain, action: .Reject, value: "cpro.baidu.com")
        let rule132 = Rule(type: .Domain, action: .Reject, value: "eclick.baidu.com")
        let rule133 = Rule(type: .Domain, action: .Reject, value: "mobads-logs.baidu.com")
        let rule134 = Rule(type: .Domain, action: .Reject, value: "mobads.baidu.com")
        let rule135 = Rule(type: .Domain, action: .Reject, value: "msg.71.am")
        let rule136 = Rule(type: .Domain, action: .Reject, value: "mtj.baidu.com")
        let rule137 = Rule(type: .Domain, action: .Reject, value: "nsclick.baidu.com")
        let rule138 = Rule(type: .DomainSuffix, action: .Reject, value: "baidustatic.com")
        let rule139 = Rule(type: .DomainSuffix, action: .Reject, value: "pos.baidu.com")
        let rule140 = Rule(type: .DomainSuffix, action: .Direct, value: "baidu.com")
        let rule141 = Rule(type: .IPCIDR, action: .Reject, value: "60.210.17.12/24")
        let rule142 = Rule(type: .Domain, action: .Reject, value: "acjs.aliyun.com")
        let rule143 = Rule(type: .Domain, action: .Reject, value: "adash.m.taobao.com")
        let rule144 = Rule(type: .DomainSuffix, action: .Reject, value: "simaba.taobao.com")
        let rule145 = Rule(type: .DomainSuffix, action: .Direct, value: "taobao.com")
        let rule146 = Rule(type: .DomainSuffix, action: .Direct, value: "alicdn.com")
        let rule147 = Rule(type: .Domain, action: .Reject, value: "ads.mopub.com")
        let rule148 = Rule(type: .Domain, action: .Reject, value: "ark.letv.com")
        let rule149 = Rule(type: .Domain, action: .Reject, value: "asimgs.pplive.cn")
        let rule150 = Rule(type: .Domain, action: .Reject, value: "csi.gstatic.com")
        let rule151 = Rule(type: .Domain, action: .Reject, value: "dsp.youdao.com")
        let rule152 = Rule(type: .Domain, action: .Reject, value: "iadsdk.apple.com")
        let rule153 = Rule(type: .Domain, action: .Reject, value: "pagead2.googlesyndication.com")
        let rule154 = Rule(type: .IPCIDR, action: .Reject, value: "221.179.140.0/24")
        let rule155 = Rule(type: .DomainSuffix, action: .Reject, value: "lh1.ggpht.com")
        let rule156 = Rule(type: .DomainSuffix, action: .Reject, value: "lh2.ggpht.com")
        let rule157 = Rule(type: .DomainSuffix, action: .Reject, value: "lh3.ggpht.com")
        let rule158 = Rule(type: .DomainSuffix, action: .Reject, value: "lh4.ggpht.com")
        let rule159 = Rule(type: .DomainSuffix, action: .Reject, value: "lh5.ggpht.com")
        let rule160 = Rule(type: .DomainSuffix, action: .Reject, value: "lh6.ggpht.com")
        let rule161 = Rule(type: .DomainSuffix, action: .Reject, value: "lh7.ggpht.com")
        let rule162 = Rule(type: .DomainSuffix, action: .Reject, value: "lh8.ggpht.com")
        let rule163 = Rule(type: .DomainSuffix, action: .Reject, value: "www.panoramio.com")
        let rule164 = Rule(type: .DomainSuffix, action: .Direct, value: "qq.com")
        let rule165 = Rule(type: .DomainMatch, action: .Direct, value: "alipay")
        let rule166 = Rule(type: .DomainMatch, action: .Direct, value: "360buy")
        let rule167 = Rule(type: .DomainSuffix, action: .Direct, value: "jd.com")
        let rule168 = Rule(type: .DomainSuffix, action: .Direct, value: "126.net")
        let rule169 = Rule(type: .DomainSuffix, action: .Direct, value: "163.com")
        let rule170 = Rule(type: .DomainSuffix, action: .Direct, value: "alicdn.com")
        let rule171 = Rule(type: .DomainSuffix, action: .Direct, value: "amap.com")
        let rule172 = Rule(type: .DomainSuffix, action: .Direct, value: "bdimg.com")
        let rule173 = Rule(type: .DomainSuffix, action: .Direct, value: "bdstatic.com")
        let rule174 = Rule(type: .DomainSuffix, action: .Direct, value: "cnbeta.com")
        let rule175 = Rule(type: .DomainSuffix, action: .Direct, value: "cnzz.com")
        let rule176 = Rule(type: .DomainSuffix, action: .Direct, value: "douban.com")
        let rule177 = Rule(type: .DomainSuffix, action: .Direct, value: "gtimg.com")
        let rule178 = Rule(type: .DomainSuffix, action: .Direct, value: "hao123.com")
        let rule179 = Rule(type: .DomainSuffix, action: .Direct, value: "haosou.com")
        let rule180 = Rule(type: .DomainSuffix, action: .Direct, value: "ifeng.com")
        let rule181 = Rule(type: .DomainSuffix, action: .Direct, value: "iqiyi.com")
        let rule182 = Rule(type: .DomainSuffix, action: .Direct, value: "jd.com")
        let rule183 = Rule(type: .DomainSuffix, action: .Direct, value: "netease.com")
        let rule184 = Rule(type: .DomainSuffix, action: .Direct, value: "qhimg.com")
        let rule185 = Rule(type: .DomainSuffix, action: .Direct, value: "sogou.com")
        let rule186 = Rule(type: .DomainSuffix, action: .Direct, value: "sohu.com")
        let rule187 = Rule(type: .DomainSuffix, action: .Direct, value: "soso.com")
        let rule188 = Rule(type: .DomainSuffix, action: .Direct, value: "suning.com")
        let rule189 = Rule(type: .DomainSuffix, action: .Direct, value: "tmall.com")
        let rule190 = Rule(type: .DomainSuffix, action: .Direct, value: "tudou.com")
        let rule191 = Rule(type: .DomainSuffix, action: .Direct, value: "weibo.com")
        let rule192 = Rule(type: .DomainSuffix, action: .Direct, value: "youku.com")
        let rule193 = Rule(type: .DomainSuffix, action: .Direct, value: "xunlei.com")
        let rule194 = Rule(type: .DomainSuffix, action: .Direct, value: "zhihu.com")
        let rule195 = Rule(type: .DomainSuffix, action: .Direct, value: "ls.apple.com")
        let rule196 = Rule(type: .DomainSuffix, action: .Direct, value: "weather.com")
        let rule197 = Rule(type: .DomainSuffix, action: .Direct, value: "weibo.cn")
        let rule198 = Rule(type: .DomainSuffix, action: .Direct, value: "weibo.com")
        let rule199 = Rule(type: .DomainSuffix, action: .Direct, value: "sinaimg.cn")
        let rule200 = Rule(type: .DomainSuffix, action: .Proxy, value: "mzstatic.com")
        let rule201 = Rule(type: .DomainMatch, action: .Proxy, value: "aka")
        let rule202 = Rule(type: .DomainSuffix, action: .Proxy, value: "me.com")
        let rule203 = Rule(type: .DomainSuffix, action: .Proxy, value: "amazonaws.com")
        let rule204 = Rule(type: .DomainSuffix, action: .Proxy, value: "android.com")
        let rule205 = Rule(type: .DomainSuffix, action: .Proxy, value: "angularjs.org")
        let rule206 = Rule(type: .DomainSuffix, action: .Proxy, value: "appspot.com")
        let rule207 = Rule(type: .DomainSuffix, action: .Proxy, value: "akamaihd.net")
        let rule208 = Rule(type: .DomainSuffix, action: .Proxy, value: "amazon.com")
        let rule209 = Rule(type: .DomainSuffix, action: .Proxy, value: "bit.ly")
        let rule210 = Rule(type: .DomainSuffix, action: .Proxy, value: "bitbucket.org")
        let rule211 = Rule(type: .DomainSuffix, action: .Proxy, value: "blog.com")
        let rule212 = Rule(type: .DomainSuffix, action: .Proxy, value: "blogcdn.com")
        let rule213 = Rule(type: .DomainSuffix, action: .Proxy, value: "blogger.com")
        let rule214 = Rule(type: .DomainSuffix, action: .Proxy, value: "blogsmithmedia.com")
        let rule215 = Rule(type: .DomainSuffix, action: .Proxy, value: "box.net")
        let rule216 = Rule(type: .DomainSuffix, action: .Proxy, value: "bloomberg.com")
        let rule217 = Rule(type: .DomainSuffix, action: .Proxy, value: "chromium.org")
        let rule218 = Rule(type: .DomainSuffix, action: .Proxy, value: "cl.ly")
        let rule219 = Rule(type: .DomainSuffix, action: .Proxy, value: "cloudfront.net")
        let rule220 = Rule(type: .DomainSuffix, action: .Proxy, value: "cloudflare.com")
        let rule221 = Rule(type: .DomainSuffix, action: .Proxy, value: "cocoapods.org")
        let rule222 = Rule(type: .DomainSuffix, action: .Proxy, value: "crashlytics.com")
        let rule223 = Rule(type: .DomainSuffix, action: .Proxy, value: "dribbble.com")
        let rule224 = Rule(type: .DomainSuffix, action: .Proxy, value: "dropbox.com")
        let rule225 = Rule(type: .DomainSuffix, action: .Proxy, value: "dropboxstatic.com")
        let rule226 = Rule(type: .DomainSuffix, action: .Proxy, value: "dropboxusercontent.com")
        let rule227 = Rule(type: .DomainSuffix, action: .Proxy, value: "docker.com")
        let rule228 = Rule(type: .DomainSuffix, action: .Proxy, value: "duckduckgo.com")
        let rule229 = Rule(type: .DomainSuffix, action: .Proxy, value: "digicert.com")
        let rule230 = Rule(type: .DomainSuffix, action: .Proxy, value: "dnsimple.com")
        let rule231 = Rule(type: .DomainSuffix, action: .Proxy, value: "edgecastcdn.net")
        let rule232 = Rule(type: .DomainSuffix, action: .Proxy, value: "engadget.com")
        let rule233 = Rule(type: .DomainSuffix, action: .Proxy, value: "eurekavpt.com")
        let rule234 = Rule(type: .DomainSuffix, action: .Proxy, value: "fb.me")
        let rule235 = Rule(type: .DomainSuffix, action: .Proxy, value: "fbcdn.net")
        let rule236 = Rule(type: .DomainSuffix, action: .Proxy, value: "fc2.com")
        let rule237 = Rule(type: .DomainSuffix, action: .Proxy, value: "feedburner.com")
        let rule238 = Rule(type: .DomainSuffix, action: .Proxy, value: "fabric.io")
        let rule239 = Rule(type: .DomainSuffix, action: .Proxy, value: "flickr.com")
        let rule240 = Rule(type: .DomainSuffix, action: .Proxy, value: "fastly.net")
        let rule241 = Rule(type: .DomainSuffix, action: .Proxy, value: "ggpht.com")
        let rule242 = Rule(type: .DomainSuffix, action: .Proxy, value: "github.com")
        let rule243 = Rule(type: .DomainSuffix, action: .Proxy, value: "github.io")
        let rule244 = Rule(type: .DomainSuffix, action: .Proxy, value: "githubusercontent.com")
        let rule245 = Rule(type: .DomainSuffix, action: .Proxy, value: "golang.org")
        let rule246 = Rule(type: .DomainSuffix, action: .Proxy, value: "goo.gl")
        let rule247 = Rule(type: .DomainSuffix, action: .Proxy, value: "gstatic.com")
        let rule248 = Rule(type: .DomainSuffix, action: .Proxy, value: "godaddy.com")
        let rule249 = Rule(type: .DomainSuffix, action: .Proxy, value: "gravatar.com")
        let rule250 = Rule(type: .DomainSuffix, action: .Proxy, value: "imageshack.us")
        let rule251 = Rule(type: .DomainSuffix, action: .Proxy, value: "imgur.com")
        let rule252 = Rule(type: .DomainSuffix, action: .Proxy, value: "jshint.com")
        let rule253 = Rule(type: .DomainSuffix, action: .Proxy, value: "ift.tt")
        let rule254 = Rule(type: .DomainSuffix, action: .Proxy, value: "j.mp")
        let rule255 = Rule(type: .DomainSuffix, action: .Proxy, value: "kat.cr")
        let rule256 = Rule(type: .DomainSuffix, action: .Proxy, value: "linode.com")
        let rule257 = Rule(type: .DomainSuffix, action: .Proxy, value: "linkedin.com")
        let rule258 = Rule(type: .DomainSuffix, action: .Proxy, value: "licdn.com")
        let rule259 = Rule(type: .DomainSuffix, action: .Proxy, value: "lithium.com")
        let rule260 = Rule(type: .DomainSuffix, action: .Proxy, value: "megaupload.com")
        let rule261 = Rule(type: .DomainSuffix, action: .Proxy, value: "mobile01.com")
        let rule262 = Rule(type: .DomainSuffix, action: .Proxy, value: "modmyi.com")
        let rule263 = Rule(type: .DomainSuffix, action: .Proxy, value: "nytimes.com")
        let rule264 = Rule(type: .DomainSuffix, action: .Proxy, value: "name.com")
        let rule265 = Rule(type: .DomainSuffix, action: .Proxy, value: "openvpn.net")
        let rule266 = Rule(type: .DomainSuffix, action: .Proxy, value: "openwrt.org")
        let rule267 = Rule(type: .DomainSuffix, action: .Proxy, value: "ow.ly")
        let rule268 = Rule(type: .DomainSuffix, action: .Proxy, value: "pinboard.in")
        let rule269 = Rule(type: .DomainSuffix, action: .Proxy, value: "ssl-images-amazon.com")
        let rule270 = Rule(type: .DomainSuffix, action: .Proxy, value: "sstatic.net")
        let rule271 = Rule(type: .DomainSuffix, action: .Proxy, value: "stackoverflow.com")
        let rule272 = Rule(type: .DomainSuffix, action: .Proxy, value: "staticflickr.com")
        let rule273 = Rule(type: .DomainSuffix, action: .Proxy, value: "squarespace.com")
        let rule274 = Rule(type: .DomainSuffix, action: .Proxy, value: "symcd.com")
        let rule275 = Rule(type: .DomainSuffix, action: .Proxy, value: "symcb.com")
        let rule276 = Rule(type: .DomainSuffix, action: .Proxy, value: "symauth.com")
        let rule277 = Rule(type: .DomainSuffix, action: .Proxy, value: "ubnt.com")
        let rule278 = Rule(type: .DomainSuffix, action: .Proxy, value: "t.co")
        let rule279 = Rule(type: .DomainSuffix, action: .Proxy, value: "thepiratebay.org")
        let rule280 = Rule(type: .DomainSuffix, action: .Proxy, value: "tumblr.com")
        let rule281 = Rule(type: .DomainSuffix, action: .Proxy, value: "twimg.com")
        let rule282 = Rule(type: .DomainSuffix, action: .Proxy, value: "twitch.tv")
        let rule283 = Rule(type: .DomainSuffix, action: .Proxy, value: "twitter.com")
        let rule284 = Rule(type: .DomainSuffix, action: .Proxy, value: "wikipedia.com")
        let rule285 = Rule(type: .DomainSuffix, action: .Proxy, value: "wikipedia.org")
        let rule286 = Rule(type: .DomainSuffix, action: .Proxy, value: "wikimedia.org")
        let rule287 = Rule(type: .DomainSuffix, action: .Proxy, value: "wordpress.com")
        let rule288 = Rule(type: .DomainSuffix, action: .Proxy, value: "wsj.com")
        let rule289 = Rule(type: .DomainSuffix, action: .Proxy, value: "wsj.net")
        let rule290 = Rule(type: .DomainSuffix, action: .Proxy, value: "wp.com")
        let rule291 = Rule(type: .DomainSuffix, action: .Proxy, value: "vimeo.com")
        let rule292 = Rule(type: .DomainSuffix, action: .Proxy, value: "youtu.be")
        let rule293 = Rule(type: .DomainSuffix, action: .Proxy, value: "ytimg.com")
        let rule294 = Rule(type: .DomainMatch, action: .Proxy, value: "blogspot")
        let rule295 = Rule(type: .DomainSuffix, action: .Proxy, value: "tapbots.com")
        let rule296 = Rule(type: .DomainSuffix, action: .Direct, value: "ykimg.com")
        let rule297 = Rule(type: .DomainSuffix, action: .Proxy, value: "medium.com")
        let rule298 = Rule(type: .DomainSuffix, action: .Direct, value: "clashroyaleapp.com")
        let rule299 = Rule(type: .DomainSuffix, action: .Direct, value: "bilibili.com")
        let rule300 = Rule(type: .DomainSuffix, action: .Direct, value: "bilibili.cn")
        let rule301 = Rule(type: .DomainSuffix, action: .Direct, value: "acgvideo.com")
        let rule302 = Rule(type: .DomainSuffix, action: .Direct, value: "outlook.com")
        let rule303 = Rule(type: .IPCIDR, action: .Proxy, value: "91.108.56.0/22")
        let rule304 = Rule(type: .IPCIDR, action: .Proxy, value: "91.108.4.0/22")
        let rule305 = Rule(type: .IPCIDR, action: .Proxy, value: "109.239.140.0/24")
        let rule306 = Rule(type: .IPCIDR, action: .Proxy, value: "149.154.160.0/20")
        let rule307 = Rule(type: .IPCIDR, action: .Direct, value: "192.168.0.0/16")
        let rule308 = Rule(type: .IPCIDR, action: .Direct, value: "10.0.0.0/8")
        let rule309 = Rule(type: .IPCIDR, action: .Direct, value: "172.16.0.0/12")
        let rule310 = Rule(type: .IPCIDR, action: .Direct, value: "127.0.0.0/8")
        
        
        
        ruleSet.addRule(rule)
        ruleSet.addRule(rule1)
        ruleSet.addRule(rule2)
        ruleSet.addRule(rule3)
        ruleSet.addRule(rule4)
        ruleSet.addRule(rule5)
        ruleSet.addRule(rule6)
        ruleSet.addRule(rule7)
        ruleSet.addRule(rule8)
        ruleSet.addRule(rule9)
        ruleSet.addRule(rule10)
        ruleSet.addRule(rule11)
        ruleSet.addRule(rule12)
        ruleSet.addRule(rule13)
        ruleSet.addRule(rule14)
        ruleSet.addRule(rule15)
        ruleSet.addRule(rule16)
        ruleSet.addRule(rule17)
        ruleSet.addRule(rule18)
        ruleSet.addRule(rule19)
        ruleSet.addRule(rule20)
        ruleSet.addRule(rule21)
        ruleSet.addRule(rule22)
        ruleSet.addRule(rule23)
        ruleSet.addRule(rule24)
        ruleSet.addRule(rule25)
        ruleSet.addRule(rule26)
        ruleSet.addRule(rule27)
        ruleSet.addRule(rule28)
        ruleSet.addRule(rule29)
        ruleSet.addRule(rule30)
        ruleSet.addRule(rule31)
        ruleSet.addRule(rule32)
        ruleSet.addRule(rule33)
        ruleSet.addRule(rule34)
        ruleSet.addRule(rule35)
        ruleSet.addRule(rule36)
        ruleSet.addRule(rule37)
        ruleSet.addRule(rule38)
        ruleSet.addRule(rule39)
        ruleSet.addRule(rule40)
        ruleSet.addRule(rule41)
        ruleSet.addRule(rule42)
        ruleSet.addRule(rule43)
        ruleSet.addRule(rule44)
        ruleSet.addRule(rule45)
        ruleSet.addRule(rule46)
        ruleSet.addRule(rule47)
        ruleSet.addRule(rule48)
        ruleSet.addRule(rule49)
        ruleSet.addRule(rule50)
        ruleSet.addRule(rule51)
        ruleSet.addRule(rule52)
        ruleSet.addRule(rule53)
        ruleSet.addRule(rule54)
        ruleSet.addRule(rule55)
        ruleSet.addRule(rule56)
        ruleSet.addRule(rule57)
        ruleSet.addRule(rule58)
        ruleSet.addRule(rule59)
        ruleSet.addRule(rule60)
        ruleSet.addRule(rule61)
        ruleSet.addRule(rule62)
        ruleSet.addRule(rule63)
        ruleSet.addRule(rule64)
        ruleSet.addRule(rule65)
        ruleSet.addRule(rule66)
        ruleSet.addRule(rule67)
        ruleSet.addRule(rule68)
        ruleSet.addRule(rule69)
        ruleSet.addRule(rule70)
        ruleSet.addRule(rule71)
        ruleSet.addRule(rule72)
        ruleSet.addRule(rule73)
        ruleSet.addRule(rule74)
        ruleSet.addRule(rule75)
        ruleSet.addRule(rule76)
        ruleSet.addRule(rule77)
        ruleSet.addRule(rule78)
        ruleSet.addRule(rule79)
        ruleSet.addRule(rule80)
        ruleSet.addRule(rule81)
        ruleSet.addRule(rule82)
        ruleSet.addRule(rule83)
        ruleSet.addRule(rule84)
        ruleSet.addRule(rule85)
        ruleSet.addRule(rule86)
        ruleSet.addRule(rule87)
        ruleSet.addRule(rule88)
        ruleSet.addRule(rule89)
        ruleSet.addRule(rule90)
        ruleSet.addRule(rule91)
        ruleSet.addRule(rule92)
        ruleSet.addRule(rule93)
        ruleSet.addRule(rule94)
        ruleSet.addRule(rule95)
        ruleSet.addRule(rule96)
        ruleSet.addRule(rule97)
        ruleSet.addRule(rule98)
        ruleSet.addRule(rule99)
        ruleSet.addRule(rule100)
        ruleSet.addRule(rule101)
        ruleSet.addRule(rule102)
        ruleSet.addRule(rule103)
        ruleSet.addRule(rule104)
        ruleSet.addRule(rule105)
        ruleSet.addRule(rule106)
        ruleSet.addRule(rule107)
        ruleSet.addRule(rule108)
        ruleSet.addRule(rule109)
        ruleSet.addRule(rule110)
        ruleSet.addRule(rule111)
        ruleSet.addRule(rule112)
        ruleSet.addRule(rule113)
        ruleSet.addRule(rule114)
        ruleSet.addRule(rule115)
        ruleSet.addRule(rule116)
        ruleSet.addRule(rule117)
        ruleSet.addRule(rule118)
        ruleSet.addRule(rule119)
        ruleSet.addRule(rule120)
        ruleSet.addRule(rule121)
        ruleSet.addRule(rule122)
        ruleSet.addRule(rule123)
        ruleSet.addRule(rule124)
        ruleSet.addRule(rule125)
        ruleSet.addRule(rule126)
        ruleSet.addRule(rule127)
        ruleSet.addRule(rule128)
        ruleSet.addRule(rule129)
        ruleSet.addRule(rule130)
        ruleSet.addRule(rule131)
        ruleSet.addRule(rule132)
        ruleSet.addRule(rule133)
        ruleSet.addRule(rule134)
        ruleSet.addRule(rule135)
        ruleSet.addRule(rule136)
        ruleSet.addRule(rule137)
        ruleSet.addRule(rule138)
        ruleSet.addRule(rule139)
        ruleSet.addRule(rule140)
        ruleSet.addRule(rule141)
        ruleSet.addRule(rule142)
        ruleSet.addRule(rule143)
        ruleSet.addRule(rule144)
        ruleSet.addRule(rule145)
        ruleSet.addRule(rule146)
        ruleSet.addRule(rule147)
        ruleSet.addRule(rule148)
        ruleSet.addRule(rule149)
        ruleSet.addRule(rule150)
        ruleSet.addRule(rule151)
        ruleSet.addRule(rule152)
        ruleSet.addRule(rule153)
        ruleSet.addRule(rule154)
        ruleSet.addRule(rule155)
        ruleSet.addRule(rule156)
        ruleSet.addRule(rule157)
        ruleSet.addRule(rule158)
        ruleSet.addRule(rule159)
        ruleSet.addRule(rule160)
        ruleSet.addRule(rule161)
        ruleSet.addRule(rule162)
        ruleSet.addRule(rule163)
        ruleSet.addRule(rule164)
        ruleSet.addRule(rule165)
        ruleSet.addRule(rule166)
        ruleSet.addRule(rule167)
        ruleSet.addRule(rule168)
        ruleSet.addRule(rule169)
        ruleSet.addRule(rule170)
        ruleSet.addRule(rule171)
        ruleSet.addRule(rule172)
        ruleSet.addRule(rule173)
        ruleSet.addRule(rule174)
        ruleSet.addRule(rule175)
        ruleSet.addRule(rule176)
        ruleSet.addRule(rule177)
        ruleSet.addRule(rule178)
        ruleSet.addRule(rule179)
        ruleSet.addRule(rule180)
        ruleSet.addRule(rule181)
        ruleSet.addRule(rule182)
        ruleSet.addRule(rule183)
        ruleSet.addRule(rule184)
        ruleSet.addRule(rule185)
        ruleSet.addRule(rule186)
        ruleSet.addRule(rule187)
        ruleSet.addRule(rule188)
        ruleSet.addRule(rule189)
        ruleSet.addRule(rule190)
        ruleSet.addRule(rule191)
        ruleSet.addRule(rule192)
        ruleSet.addRule(rule193)
        ruleSet.addRule(rule194)
        ruleSet.addRule(rule195)
        ruleSet.addRule(rule196)
        ruleSet.addRule(rule197)
        ruleSet.addRule(rule198)
        ruleSet.addRule(rule199)
        ruleSet.addRule(rule200)
        ruleSet.addRule(rule201)
        ruleSet.addRule(rule202)
        ruleSet.addRule(rule203)
        ruleSet.addRule(rule204)
        ruleSet.addRule(rule205)
        ruleSet.addRule(rule206)
        ruleSet.addRule(rule207)
        ruleSet.addRule(rule208)
        ruleSet.addRule(rule209)
        ruleSet.addRule(rule210)
        ruleSet.addRule(rule211)
        ruleSet.addRule(rule212)
        ruleSet.addRule(rule213)
        ruleSet.addRule(rule214)
        ruleSet.addRule(rule215)
        ruleSet.addRule(rule216)
        ruleSet.addRule(rule217)
        ruleSet.addRule(rule218)
        ruleSet.addRule(rule219)
        ruleSet.addRule(rule220)
        ruleSet.addRule(rule221)
        ruleSet.addRule(rule222)
        ruleSet.addRule(rule223)
        ruleSet.addRule(rule224)
        ruleSet.addRule(rule225)
        ruleSet.addRule(rule226)
        ruleSet.addRule(rule227)
        ruleSet.addRule(rule228)
        ruleSet.addRule(rule229)
        ruleSet.addRule(rule230)
        ruleSet.addRule(rule231)
        ruleSet.addRule(rule232)
        ruleSet.addRule(rule233)
        ruleSet.addRule(rule234)
        ruleSet.addRule(rule235)
        ruleSet.addRule(rule236)
        ruleSet.addRule(rule237)
        ruleSet.addRule(rule238)
        ruleSet.addRule(rule239)
        ruleSet.addRule(rule240)
        ruleSet.addRule(rule241)
        ruleSet.addRule(rule242)
        ruleSet.addRule(rule243)
        ruleSet.addRule(rule244)
        ruleSet.addRule(rule245)
        ruleSet.addRule(rule246)
        ruleSet.addRule(rule247)
        ruleSet.addRule(rule248)
        ruleSet.addRule(rule249)
        ruleSet.addRule(rule250)
        ruleSet.addRule(rule251)
        ruleSet.addRule(rule252)
        ruleSet.addRule(rule253)
        ruleSet.addRule(rule254)
        ruleSet.addRule(rule255)
        ruleSet.addRule(rule256)
        ruleSet.addRule(rule257)
        ruleSet.addRule(rule258)
        ruleSet.addRule(rule259)
        ruleSet.addRule(rule260)
        ruleSet.addRule(rule261)
        ruleSet.addRule(rule262)
        ruleSet.addRule(rule263)
        ruleSet.addRule(rule264)
        ruleSet.addRule(rule265)
        ruleSet.addRule(rule266)
        ruleSet.addRule(rule267)
        ruleSet.addRule(rule268)
        ruleSet.addRule(rule269)
        ruleSet.addRule(rule270)
        ruleSet.addRule(rule271)
        ruleSet.addRule(rule272)
        ruleSet.addRule(rule273)
        ruleSet.addRule(rule274)
        ruleSet.addRule(rule275)
        ruleSet.addRule(rule276)
        ruleSet.addRule(rule277)
        ruleSet.addRule(rule278)
        ruleSet.addRule(rule279)
        ruleSet.addRule(rule280)
        ruleSet.addRule(rule281)
        ruleSet.addRule(rule282)
        ruleSet.addRule(rule283)
        ruleSet.addRule(rule284)
        ruleSet.addRule(rule285)
        ruleSet.addRule(rule286)
        ruleSet.addRule(rule287)
        ruleSet.addRule(rule288)
        ruleSet.addRule(rule289)
        ruleSet.addRule(rule290)
        ruleSet.addRule(rule291)
        ruleSet.addRule(rule292)
        ruleSet.addRule(rule293)
        ruleSet.addRule(rule294)
        ruleSet.addRule(rule295)
        ruleSet.addRule(rule296)
        ruleSet.addRule(rule297)
        ruleSet.addRule(rule298)
        ruleSet.addRule(rule299)
        ruleSet.addRule(rule300)
        ruleSet.addRule(rule301)
        ruleSet.addRule(rule302)
        ruleSet.addRule(rule303)
        ruleSet.addRule(rule304)
        ruleSet.addRule(rule305)
        ruleSet.addRule(rule306)
        ruleSet.addRule(rule307)
        ruleSet.addRule(rule308)
        ruleSet.addRule(rule309)
        ruleSet.addRule(rule310)
        do {
            try DBUtils.add(ruleSet)
        }catch {
            NSLog("保存规则集失败")
        }

        appendRuleSet(ruleSet)
    }

    func Seven_postEmptyMsg() {
        // Post an empty message so we could attach to packet tunnel process
        Manager.sharedManager.postMessage()
    }
    
    func chooseConfigGroups() {
        ConfigGroupChooseManager.shared.show()
    }

    func showAddConfigGroup() {
        var urlTextField: UITextField?
        let alert = UIAlertController(title: "Add Config Group".localized(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name".localized()
            urlTextField = textField
        }
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action) in
            if let input = urlTextField?.text {
                do {
                    try self.addEmptyConfigGroup(input)
                }catch{
                    Alert.show(self.vc, message: "\("Failed to add config group".localized()): \(error)")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    func addEmptyConfigGroup(_ name: String) throws {
        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedName.characters.count == 0 {
            throw "Name can't be empty".localized()
        }
        let group = ConfigurationGroup()
        group.name = trimmedName
        try DBUtils.add(group)
        CurrentGroupManager.shared.setConfigGroupId(group.uuid)
    }
    
    func addRuleSet() {
        let destVC: UIViewController
        if defaultRealm.objects(RuleSet).count == 0 {
            destVC = RuleSetConfigurationViewController() { [unowned self] ruleSet in
                self.appendRuleSet(ruleSet)
            }
        }else {
            destVC = RuleSetListViewController { [unowned self] ruleSet in
                self.appendRuleSet(ruleSet)
            }
        }
        if (vc.navigationController != nil) {
            vc.navigationController?.pushViewController(destVC, animated: true)
        } else {
            let nav = UINavigationController(rootViewController: destVC)
            
            vc.present(nav, animated: true, completion: nil)
        }
        
    }

    func appendRuleSet(_ ruleSet: RuleSet?) {
        guard let ruleSet = ruleSet, !group.ruleSets.contains(ruleSet) else {
            return
        }
        do {
            try ConfigurationGroup.appendRuleSet(forGroupId: group.uuid, rulesetId: ruleSet.uuid)
            self.delegate?.handleRefreshUI()
        }catch {
            self.vc.showTextHUD("\("Fail to add ruleset".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
        }
    }

    func updateDNS(_ dnsString: String) {
        var dns: String = ""
        let trimmedDNSString = dnsString.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedDNSString.characters.count > 0 {
            let dnsArray = dnsString.components(separatedBy: ",").map({ $0.components(separatedBy: "，") }).flatMap({ $0 }).map({ $0.trimmingCharacters(in: CharacterSet.whitespaces)}).filter({ $0.characters.count > 0 })
            let ipRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
            guard let regex = try? Regex(ipRegex) else {
                fatalError()
            }
            let valids = dnsArray.map({ regex.test($0) })
            let valid = valids.reduce(true, { $0 && $1 })
            if !valid {
                dns = ""
                Alert.show(self.vc, title: "Invalid DNS".localized(), message: "DNS should be valid ip addresses (separated by commas if multiple). e.g.: 8.8.8.8,8.8.4.4".localized())
            }else {
                dns = dnsArray.joined(separator: ",")
            }
        }
        do {
            try ConfigurationGroup.changeDNS(forGroupId: group.uuid, dns: dns)
        }catch {
            self.vc.showTextHUD("\("Fail to change dns".localized()): \((error as NSError).localizedDescription)", dismissAfterDelay: 1.5)
        }
    }

    func onVPNStatusChanged() {
        self.delegate?.handleRefreshUI()
    }

    func changeGroupName() {
        var urlTextField: UITextField?
        let alert = UIAlertController(title: "Change Name".localized(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Input New Name".localized()
            urlTextField = textField
        }
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [unowned self] (action) in
            if let newName = urlTextField?.text {
                do {
                    try ConfigurationGroup.changeName(forGroupId: self.group.uuid, name: newName)
                }catch {
                    Alert.show(self.vc, title: "Failed to change name", message: "\(error)")
                }
                self.delegate?.handleRefreshUI()
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

}

class CurrentGroupManager {

    static let shared = CurrentGroupManager()

    fileprivate init() {
        _groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
    }

    var onChange: ((ConfigurationGroup?) -> Void)?

    fileprivate var _groupUUID: String {
        didSet(o) {
            self.onChange?(group)
        }
    }

    var group: ConfigurationGroup {
        if let group = DBUtils.get(_groupUUID, type: ConfigurationGroup.self, filter: "deleted = false") {
            return group
        } else {
            let defaultGroup = Manager.sharedManager.defaultConfigGroup
            setConfigGroupId(defaultGroup.uuid)
            return defaultGroup
        }
    }

    func setConfigGroupId(_ id: String) {
        if let _ = DBUtils.get(id, type: ConfigurationGroup.self, filter: "deleted = false") {
            _groupUUID = id
        } else {
            _groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
        }
    }
    
}
