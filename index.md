# BILIBILI-HELPER

[![GitHub stars](https://img.shields.io/github/stars/xxxbrian/BILIBILI-HELPER?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/stargazers) [![GitHub forks](https://img.shields.io/github/forks/xxxbrian/BILIBILI-HELPER?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/network) [![GitHub issues](https://img.shields.io/github/issues/xxxbrian/BILIBILI-HELPER?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/issues) [![GitHub license](https://img.shields.io/github/license/xxxbrian/BILIBILI-HELPER?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/blob/main/LICENSE) [![GitHub All Releases](https://img.shields.io/github/downloads/xxxbrian/BILIBILI-HELPER/total?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/releases) [![GitHub contributors](https://img.shields.io/github/contributors/xxxbrian/BILIBILI-HELPER?style=flat-square)](https://github.com/xxxbrian/BILIBILI-HELPER/graphs/contributors) ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/xxxbrian/BILIBILI-HELPER?style=flat-square)

## 功能列表

- [x] 通过docker或者云函数执行定时任务。_【运行时间可自定义】_
- [x] 哔哩哔哩漫画每日自动签到，自动阅读 1 章节 。
- [x] 每日自动从热门视频中随机观看 1 个视频，分享一个视频。
- [x] 每日从热门视频中选取 5 个进行智能投币 _【如果投币已无法继续获得经验，则自动取消】_
- [x] 投币支持下次一定啦，可自定义每日投币数量。_【如果检测到已经投币，则自动取消】_
- [x] 大会员月底使用快到期的 B 币券，给自己充电，一点也不会浪费哦，默认开启。_【已支持给指定 UP 充电】_
- [x] 大会员月初 1 号自动领取每月 5 张 B 币券和福利。
- [x] 每日哔哩哔哩直播自动签到，领取签到奖励。
- [x] Linux 用户支持自定义配置。
- [x] 投币策略更新可配置投币喜好。_【可配置优先给关注的 up 投币】_
- [x] 自动送出即将过期的礼物。 _【默认开启，未更新到新版本的用户默认关闭】_
- [x] 支持推送执行结果到微信，钉钉，telegram等。

[点击快速开始使用](#使用说明)

[点击快速查看自定义功能配置](#自定义功能配置)

# 目录

- [目录](#目录)
  - [使用说明](#使用说明)
    - [获取运行所需的 Cookies](#获取运行所需的-cookies)
    - [Linux Crontab 部署](#linux-crontab-部署)
    - [自定义功能配置](#自定义功能配置)
      - [配置文件参数示意](#配置文件参数示意)
      - [userAgent 可选参数列表](#useragent-可选参数列表)
  - [订阅执行结果](#订阅执行结果)
    - [Server 酱 Turbo 版](#server-酱-turbo-版)
    - [Telegram 订阅执行结果](#telegram-订阅执行结果)
    - [钉钉机器人](#钉钉机器人)
    - [PushPlus(Push+)](#pushpluspush)
  - [参考列表](#参考列表)

## 使用说明

### 获取运行所需的 Cookies

1. **获取 Bilibili Cookies**
2. 浏览器打开并登录 [Bilibili](bilibili.com)
3. 按 F12 打开 「开发者工具」 找到 应用程序/Application -\> 存储\Storage -\> Cookies
4. 记录 `bili_jct` `SESSDATA` `DEDEUSERID` 三项的值

### Linux Crontab 部署

在 linux shell 环境执行以下命令，并按照提示输入参数(`bili_jct`, `SESSDATA`, `DEDEUSERID`)

```shell
wget https://raw.githubusercontent.com/xxxbrian/BILIBILI-HELPER/main/setup.sh && chmod +x ./setup.sh && sudo ./setup.sh && rm -rf ./setup.sh
```

**手动 crontab 命令示例**  (上面的一键脚本已包含crontab设置)
`30 10 * * * sh /home/start.sh`

| args              | 说明               |
| ----------------- | ------------------ |
| 30 10 \* \* \*    | `crontab` 定时时间 |
| sh /home/start.sh | `start.sh`的路径   |

```shell
#!/bin/bash
source /etc/profile
source ~/.bashrc
source ~/.zshrc #其他终端请自行引入环境变量
echo $PATH
java -jar /home/BILIBILI-HELPER.jar DEDEUSERID SESSDATA BILI_JCT >> /var/log/bilibili-help.log
# 注意将jar包路径替换为实际路径。将参数修改为刚刚获取的参数，cookies中含有% * 等特殊字符需要转义。
```

**命令示例：**

```shell
# *如果Cookies参数中包含特殊字符，例如`%`请使用`\`转义*,如果不执行可在命令前增加 source /etc/profile
30 10 * * * java -jar /home/BILIBILI-HELPER.jar DEDEUSERID SESSDATA BILI_JCT >> /var/log/bilibili-help.log &
```

### 自定义功能配置

配置文件示例：

```json
{
  "taskIntervalTime": 10,
  "numberOfCoins": 5,
  "reserveCoins": 50,
  "selectLike": 0,
  "monthEndAutoCharge": true,
  "giveGift": true,
  "upLive": "0",
  "chargeForLove": "0",
  "devicePlatform": "ios",
  "coinAddPriority": 1,
  "skipDailyTask": false,
  "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
}
```

使用 jar 包时，`release`包中会包含一份`config.json`配置文件，只需将其和`BILIBILI-HELP.jar`放在同一目录即可，执行时优先加载外部配置文件

#### 配置文件参数示意

| Key                | Value                | 说明                                                                     |
| ------------------ | -------------------- | ------------------------------------------------------------------------ |
| taskIntervalTime   | [1,无穷大]            | 任务之间的执行间隔,默认10秒,云函数用户不建议调整的太长，注意免费时长。 |
| numberOfCoins      | [0,5]                | 每日投币数量,默认 5 ,为 0 时则不投币                                     |
| reserveCoins       | [0,4000]             | 预留的硬币数，当硬币余额小于这个值时，不会进行投币任务，默认值为 50      |
| selectLike         | [0,1]                | 投币时是否点赞，默认 0, 0：否 1：是                                      |
| monthEndAutoCharge | [false,true]         | 年度大会员月底是否用 B 币券给自己充电，默认 `true`，即充电对象是你本人。 |
| giveGift           | [false,true]         | 直播送出即将过期的礼物，默认开启，如需关闭请改为 false                   |
| upLive             | [0,送礼 up 主的 uid] | 直播送出即将过期的礼物，指定 up 主，为 0 时则随随机选取一个 up 主        |
| chargeForLove      | [0,充电对象的 uid]   | 给指定 up 主充电，值为 0 或者充电对象的 uid，默认为 0，即给自己充电。    |
| devicePlatform     | [ios,android]        | 手机端漫画签到时的平台，建议选择你设备的平台 ，默认 `ios`                |
| coinAddPriority    | [0,1]                | 0：优先给热榜视频投币，1：优先给关注的 up 投币                           |
| userAgent          | 浏览器 UA            | 用户可根据部署平台配置，可根据 userAgent 参数列表自由选取                |
| skipDailyTask      | [false,true]         | 是否跳过每日任务，默认`true`,如果关闭跳过每日任务，请改为`false`         |

**如果你没有上传过视频并开启充电计划，充电会失败，B 币券会浪费。此时建议配置为给指定的 up 主充电。**

#### userAgent 可选参数列表

| 平台      | 浏览器         | userAgent                                                                                                                           |
| --------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Windows10 | EDGE(chromium) | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36 Edg/86.0.622.69 |
| Windows10 | Chrome         | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36                 |
| masOS     | safari         | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15               |
| macOS     | Firefox        | Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:65.0) Gecko/20100101 Firefox/65.0                                                  |
| macOS     | Chrome         | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36            |

**如果尝试给关注的 up 投币十次后，还没完成每日投币任务，则切换成热榜模式，给热榜视频投币**_(投币数量代码做了处理，如果本日投币不能获得经验了，则不会投币，每天只投能获得经验的硬币。假设你设置每日投币 3 个，早上 7 点你自己投了 2 个硬币，则十点半时，程序只会投 1 个）_

## 订阅执行结果

### Server 酱 Turbo 版

目前 Turbo 版本的消息通道支持以下渠道

- 企业微信应用消息
- Android，
- Bark iOS，
- 企业微信群机器人
- 钉钉群机器人
- 飞书群机器人
- 自定义微信测试号
- 方糖服务号

1. 前往 [sct.ftqq.com](https://sct.ftqq.com/sendkey)点击登入，创建账号。
2. 点击点[SendKey](https://sct.ftqq.com/sendkey) ，生成一个 Key 变量名为 `SERVERPUSHKEY`
3. [配置消息通道](https://sct.ftqq.com/forward) ，选择方糖服务号，保存即可。

**旧版推送渠道[sc.ftqq.com](http://sc.ftqq.com/9.version0) 即将与 4 月底下线，请前往[sct.ftqq.com](https://sct.ftqq.com/sendkey)生成`Turbo`版本的`Key`，注意，申请 Turbo 版 Key 后请配置消息通道，如果想沿用以前的推送方式，选择方糖服务号即可**

### Telegram 订阅执行结果

1. 在 Telegram 中添加 `BotFather` 这个账号，然后依次发送`/start` `/newbot` 按照提示即可创建一个新的机器人。记下来给你生成的 `token`。

2. 搜索刚刚创建的机器人的名字，并给它发送一条消息。_（特别注意：需要先与机器人之间创建会话，机器人才能下发消息，否则机器人无法主动发送消息，切记！）_

3. 在 Telegram 中搜索 `userinfobot`，并给它发送一条消息，它会返回给你 `chatid`

4. 删除 `SERVERPUSHKEY`，添加 `TELEGRAMBOTTOKEN`，`TELEGRAMCHATID`

### 钉钉机器人

1. 首先注册钉钉企业 [快速注册](https://oa.dingtalk.com/register.html)

2. [进入钉钉开放平台添加机器人](https://open-dev.dingtalk.com/#/corprobot)

3. 添加自定义关键词：BILIBILI

4. 将`SERVERPUSHKEY` 的值更新成机器人的 `Webhook`
例如:`https://oapi.dingtalk.com/robot/send?access_token=XXX`

5. 完成

### PushPlus(Push+)

1. [前往 PushPlus 获取 Token](https://www.pushplus.plus/push1.html)

2. 将 `SERVERPUSHKEY` 的值更新成获取到的 `Token`

3. 完成

## 参考列表

- [JunzhouLiu/BILIBILI-HELPER](https://github.com/JunzhouLiu/BILIBILI-HELPER)
- [SocialSisterYi/bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [happy888888/BiliExp](https://github.com/happy888888/BiliExp)
