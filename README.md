*PS* 感谢大家的关注，由于我本想开源4个库，除了router, 另外三个分别是native dispatcher, web dispatcher 和 react dispatcher , 所以router 对native dispatcher 有了库依赖，为了共同学习，我把router单独分离成pod，再次感谢大家的关注，欢迎叫router更完善。best regards.

# 如何优雅的实现界面跳转 之 统跳协议 - DarwinNativeRouter

## 预热  - 我要解决的问题

> 首先我还是要推荐Gaosboy的这篇文章[解耦神器 —— 统跳协议和Rewrite引擎](http://pingguohe.net/2015/11/24/Navigator-and-Rewrite.html)
> 文章中，介绍了天猫app，基于文件配置和uri的页面跳转。这大大增加了app端的灵活性， 而这种实现很类似今天的前端或后端开发中的 静态路由 和 动态路由协议。
> 除了天猫，在很多的客户端架构的文章中，路由解耦的案例并不不少见，如[携程移动App架构优化之旅](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=403009403&idx=1&sn=d19264fa1d06b9c5a9dfb1d192a0ed8e&scene=1&srcid=0401q08nZugjahvHG8rIXA3D&key=710a5d99946419d9421e8fbc5fb565c3a91aaaba22b5db9dffc9bcfae33aa18f533fbe82c6c570fec3720d82be5b9b5a&ascene=0&uin=MTMzODgyNTU%3D&devicetype=iMac+MacBookPro10%2C1+OSX+OSX+10.11+build(15A282b)&version=11000004&pass_ticket=IbzhLj2Kxa98XTnVDWywF6o6dyAlCik592Btwh3yT4A%3D)
> [蘑菇街App的组件化之路](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=402696366&idx=1&sn=ba8cbd75849b9657175c4b25bb0ac5b5&scene=1&srcid=0401oAmP7sfKiXI2di3pJuOk&key=710a5d99946419d91e680351171de6fada2f6c71eaae2e235c5d4c37c97363d6a9d3cd45dd9ab9cdcccf2a0e701d01c5&ascene=0&uin=MTMzODgyNTU%3D&devicetype=iMac+MacBookPro10%2C1+OSX+OSX+10.11+build(15A282b)&version=11000004&pass_ticket=IbzhLj2Kxa98XTnVDWywF6o6dyAlCik592Btwh3yT4A%3D)
> 原生路由协议， 其实两年前就有了类似的实现。比如900+Star的[HHRouter](https://github.com/Huohua/HHRouter)，而作者是当时还在布丁动画工作的Light。2015年我有幸见到本人，人很nice，并真是全栈。
> DarwinNativeRouter 在接口设计上，很大程度上的参考了现有的react路由协议 react router。并且对原生跳转方式保留很大的可扩展性。所以我的初衷 DarwinNativeRouter 是一个足够轻量级的框架。Light & Flexible。

## 全局路由协议能解决的问题

### 错中复杂的Controller的跳转依赖

> 在iOS的世界里，传统的Controller跳转方式， A 跳转 B， 则 A 必须持有 B 的对象。 而在app长大的过程中， 势必会造成 A －> B , B -> C, A -> C D, E, F...
> 从而产生复杂的依赖链。全局的Router 使 A 不必依赖于 特定的 Controller 便可以实现跳转。

如下面跳转：

We Always Do:

```

  UIViewController *personal = [UIViewController new];
  personal.userId = @"10238372";
  [self.navigationController pushViewController:personal animated:NO];
  


```

Router Code:

```

      [[DNRouter router]open:@"./user/10238372/profile"];

```

又比如我们要在navigationController根路径跳转

We Always Do:

```
  [self.navigationController popToRootViewControllerAnimated:NO];
  UIViewController *personal = [UIViewController new];
  personal.userId = @"10238372";
  [self.navigationController pushViewController:personal animated:YES];

```

Router Code:

```

      [[DNRouter router]open:@"/user/10238372/profile"];

```

### 推送通知，点击打开指定页面

> 对于这种需求， 相信，目前最多的实现应该是两种， 一种的传参的Url， 而另一种，是传递int类型，并通过类似switch case对参数值的硬编码，实现跳转逻辑。
> 我是很反感第二种的跳转方式， 1. int毫无疑义， 只能硬解释。 2. 跳转的页面有限。 当然如果url采用硬编码， 也是跳转有限的。
> 而有了router，一切不一样。

1. 从didFinishLaunchingWithOptions 和 didReceiveRemoteNotification捕获payload

2. 跳用Router

Somethings we may do:

```
switch (type) {
  case 1001:
    //jumping code
    break;

  case 1002:
    //jumping code
    break;
  case 1003:
    //jumping code
    break;
  case 1004:
    //jumping code
    break;

  default:
    break;
  }
```

Now we need do:
```
if([[DNRouter router]canOpen:url.absoluteString])  [[DNRouter router]open:url.absoluteString];

```
### app间通讯 及 deeplink

> Router 可以轻松handle deeplink。 deeplink 即： 从safari打开app的指定页面。 这方面做得比较好的， 如新浪微博的app， 在点击对应的新浪微博热点 条目时， 就发生了跳转，并跳到了条目详情。
> Router， 同样可以被用作 app 间通讯， 和 deeplink 的原理相同。uri的通讯方式，被认为是最简单的app间通讯。 如我们常常使用的微信分享，配置的 scheme 就是用来做跳转和通讯的。

Router Code

```

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
  if([[DNRouter router]canOpen:url.absoluteString])
  {
    [[DNRouter router]open:url.absoluteString];
    return YES;
  }
  return NO;
}

```
### 一致的行为处理， Hybrid & React Native

> 有了Router， 你可以使这些跳转 有一致的行为。

## DarwinNativeRouter 特性


### 静态路由 ／user

```
[DNRouter routerWithName:@"profile" path:@"/user"
    navigationController:(UINavigationController *)self.window.rootViewController
              controller:^__kindof UIViewController *{

  UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
  return controller;

} action:^(__kindof UIViewController *controller) {

  [DNDispatcher dispatcher].defaultNavigationController.animation(YES).pushViewController(controller);

}];

```


### 动态路由 /user/:id

```
[DNRouter routerWithName:@"profile" path:@"/user/:id"
    navigationController:(UINavigationController *)self.window.rootViewController
              controller:^__kindof UIViewController *{

  UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
  return controller;

} action:^(__kindof UIViewController *controller) {

  [DNDispatcher dispatcher].defaultNavigationController.animation(YES).pushViewController(controller);
  // 希望大家注意下动画的设置，若animation设为YES, 容易造成animation system的混乱，需要保证最后一个push的前的所有controller的动画为NO.

}];

```
### 更方便的跳转，名称跳转 name jumping

```
  [[DNRouter router]redirect:@"profile"];

```

### 相对路径跳转

```
//跟路径
[[DNRouter router]open:@"/user"];

//当前路径
[[DNRouter router]open:@"./user"];

//上一级
[[DNRouter router]open:@"../user"];

```
### 易扩展， 自定义跳转 action

```
[DNRouter routerWithName:@"profile" path:@"/user/:id"
    navigationController:(UINavigationController *)self.window.rootViewController
              controller:^__kindof UIViewController *{

  UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"kMainBoard"];
  return controller;

} action:^(__kindof UIViewController *controller) {

  [DNDispatcher dispatcher].defaultNavigationController.animation(YES).pushViewController(controller);
  // 希望大家注意下动画的设置，若animation设为YES, 容易造成animation system的混乱，需要保证最后一个push的前的所有controller的动画为NO.

}];

```
### 默认行为，及 异常处理，index & 404

```
// index page
[DNRouter defaultRouterWithController:^__kindof UIViewController *{

} action:^(__kindof UIViewController *controller) {

}];

// 404 page
[DNRouter notFoundRouterWithController:^__kindof UIViewController *{

} action:^(__kindof UIViewController *controller) {

}];

```

## 后言

DarwinNativeRouter 现在还没有到1.0版本，还有很多可以想象的东西，欢迎让他更加完善，和提pr。
[DarwinNativeRouter's Github](https://github.com/oenius/DarwinNativeRouter)


@author Jou [Email](jou@oenius.com) [Weibo](http://weibo.com/monfur) or [Github](https://github.com/oenius)
