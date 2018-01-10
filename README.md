# IW
IW Extension \
一套快速开发框架, 集成了许多日常使用的方法
\
\
`适用于`: `iOS`, `Swift 4.0`
\
\
**安装方法**
```
pod 'IW'
```
\
\
**扩展详情说明**
参见: [详情说明](http://iwecon.cc/index.php/archives/7/) \
有任何疑问或使用过程中出现的问题, 请发 `Issues` 告知, 就此先`谢`过了


# 更新说明
#### 2018.0110
期间修改了不少东西，并且支持 `CocoaPods` 安装了！喜大普奔 折腾了好久 ~_~||| \
新增加了 `类名`、`方法名` 的 `中文注释`; \
新增加了 `IWRootVC` 两个属性 `isEnterByPop` 和 `isEnterByPush` , 功能分别为判断该视图`是否为push进入`, `是否为pop进入`; \

#### 2017.1204
`A`&ensp;新增 `UIColor+IW` 用于处理颜色这一块儿; \
`A`&ensp;新增 `UIImage+IW` 用于处理图片这一块儿; \
`A`&ensp;`UIView+IW` 新增 `showDebugColor`: 给子视图添加背景颜色, 方便调试; \
`A`&ensp;`UIViewController+IW` 新增 `close`方法(自动判断是pop还是dismiss); \
`A`&ensp;`IWExtension.swift` -> `extension String` 新增类方法 `hexString` 和 `hexLetterString` 两个方法, 用于转换为16进制字符串; \
&emsp;&ensp;新增 `extension CGSize`, `isEmpty`: 判断`size`是否为空; \
`A`&ensp;`String+IW` 新增方法 `trim`、`trimWithSpace`、`trimLineBreakCharacter`、`md5`、`timeWithMinsAndSecs`; \
`A`&ensp;`UILabel+IW` 新增方法 `same(as:)`: 将目标label的样式(`font`、`textColor`、`backgroundColor`、`lineBreakMode`、`textAlignment`)复制到当前label; \
`A`&ensp;`UIImageView+IW` 新增方法 `sizeToFitKeepingImageAdpectRatio`: 把 `UIImageView` 的宽高调整为能保持 `image` 宽高比例不变的同时又不超过给定的 `limitSize` 大小的最大`frame`, 建议在设置完 `x/y` 之后使用; \
`A`&ensp;`UIImage+IW` 新增 `averageColor`: 取图片均色; \
&emsp;&ensp;`grayImage`: 将图片置灰; \
&emsp;&ensp;`opaque`: 图片是否包含透明通道; \
&emsp;&ensp;`alpha`: 设置图片透明度; \
&emsp;&ensp;`tintColor`: 保持图片形状不变, 使用指定的颜色填充; \
&emsp;&ensp;`blendColor`: 保持图片的形状和纹理不变, 使用指定的颜色渲染; \
`A`&ensp;`UIColor+IW` 新增 `isDark`: 是否为暗色;\
&emsp;&ensp;`inverseColor`: 返回反色; \
&emsp;&ensp;`randomColor`: 返回一个随机色; \
&emsp;&ensp;`hex`: 返回色值的16进制代码, 颜色通道排序为 RGBA; \
&emsp;&ensp;`colorWithoutAlpha`: 返回去除透明通道(将透明值设置为1.0)的颜色; \
&emsp;&ensp;`red`、`green`、`blue`、`alpha`、`hue`、`saturation`、`brightness`: 返回对应通道的值; \
&emsp;&ensp;`image`: 返回一张 `4x4` 的纯色图片;  
&emsp;&ensp;`image(withColor: size: cornerRadius:)`: 返回一张自定义的纯色图片; \
`A`&ensp;`String+IW` 新增 `loadFileContents`: 将路径文件读取为`utf8`的字符串; \
`A`&ensp;新增`Data+IW`, 包含 `string` 和 `stringValue`; \
`A`&ensp;新增`CGSize+IW`, 包含 `rect` 和 `fixSize`; \
`A`&ensp;`Array+IW` 新增 `enumeratedNested`: 将多维数组按照一维数组进行遍历; \
`A`&ensp;`IWGlobal.swift` 新增 `MakePoint`; 

`C`&ensp;修改部分文件命名, 采用 `类+IW` 进行命名; \
`C`&ensp;`UIViewController+IW` 修改方法名 `dimiss` 为 `dismiss(viewControllerWithAnimated animated: Bool)`; \
`C`&ensp;`UIView+IW` 修改方法 `addTo` 为 `addTo(view: UIView?, setToViewBounds: Bool = false)`; \
`C`&ensp;`UITableViewHeaderFooterView+IW` 修改方法 `fixbackgroundColorWarning` 实现Code; \
`C`&ensp;`IWExtension.swift` -> `statusBarHeight` 结果改为实时获取, 避免打电话的时候的动态高度; 

`F`&ensp;`IWExtension.swift` 修复 `tabbarHeight` 和 `statusBarheight` 的获取逻辑; 

#### 2017.1201
`C` 修改 `IWLocalAuthentication` 部分变量定义; 

#### 2017.1130
`A` 新增 `IWLocalAuthentication` 类, 用于本地认证 ( `Face ID` / `Touch ID`); \
使用例子：[参见使用说明](http://iwecon.cc/index.php/archives/16/);
