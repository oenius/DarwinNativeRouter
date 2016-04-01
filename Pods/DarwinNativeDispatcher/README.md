
# 如何优雅的实现界面跳转 之 原生界面跳转的统跳实践 - DarwinNativeDispatcher

## 预热  - 我要解决的问题

> app长大的过程中，也是我们痛苦的过程。如果不暂停一下重构代码，以后开发的过程中会是分分钟日了狗。
> 首先推荐Gaosboy的一篇文章[解耦神器 —— 统跳协议和Rewrite引擎](http://pingguohe.net/2015/11/24/Navigator-and-Rewrite.html)
> 文章中，介绍了天猫app，基于文件配置和uri的页面跳转。这大大增加了app端的灵活性， 而这种实现很类似今天的前端或后端开发中的 静态路由 和 动态路由协议。
> 有了思想， 没有实现， 所以DarwinNativeDispatcher是这种Thinking下的产物。
> DarwinNativeDispatcher针对性的解决原生界面间的跳转问题，但它并不涉及实现任何的路由协议。

为了更好地理解， 我举个栗子（对是栗子）：

场景0.  
> 用户重新登录，需要重新布局根部的rootviewcontroller，如tabbarcontroller 并重新选到默认的第一项

场景1.  
> 在某些特殊情况下， 你不得不在view中调用方法，跳转界面。

场景2.
> 实现自定义的alert窗，常需要实现很多次要逻辑，如自定义window，

场景3.
> 在某些ue下，你需要替换rootcontroller  

相信我， 在遇到类似问题的时候，你不必再在appdelegate 或 其分类中，写跳转逻辑，或是不停的获取rootcontroller造成一些ugly的代码。  
你完全可以试试DarwinNativeDispatcher， 经过简单的初始化，它可以轻松handle这些问题，包括聚美app的那种奇葩的结构。

在DarwinNativeDispatcher之后，我还在写三个框架，他们分别是

1. DarwinHybridDispatcher 针对web页面的分派器
2. DarwinReactDispatcher 针对react native页面的分派器
3. DarwinRouter 针对统跳的路由协议

## 如何使用  - DarwinNativeDispatcher

没错，DarwinNativeDispatcher在表现上，也是我链式编程的一次实践。

1. 引入DarwinNativeDispatcher

``
#import "DarwinNativeDispatcher.h"

``

2. 如果你的rootcontroller是 tabbarcontroller 或是 navigationController

``

[DNDispatcher dispatcher].defaultTabbarController.pushViewController(controller);

// or

[DNDispatcher dispatcher].defaultNavigationController.pushViewController(controller);

``

3. 替换rootcontroller

``
UIViewController *controller = [[UIViewController alloc]init];
controller.view.backgroundColor = [UIColor orangeColor];

[DNDispatcher dispatcher].rootViewController.replaceRootControllerWithController(controller);

``

4. 实现自己的alert对话框

``

UIViewController *controller = [[UIViewController alloc]init];
controller.view.backgroundColor = [UIColor orangeColor];

[[DNDispatcher dispatcher].alertViewController clearColor];

//show it
[DNDispatcher dispatcher].alertViewController.show(controller);

//hide it
[[DNDispatcher dispatcher].alertViewController hide];

``

## 后言

DarwinNativeDispatcher 现在还没有到1.0版本，还有很多可以想象的东西，欢迎让他更加完善，和提pr。
[DarwinNativeDispatcher's Github](https://github.com/oenius/DarwinNativeDispatcher)


@author Jou [Email](jou@oenius.com) [Weibo](http://weibo.com/monfur) or [Github](https://github.com/oenius)
`
