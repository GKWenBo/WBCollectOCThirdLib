# NetworkStauts
三种网络状态检测方法介绍：

* 苹果提供的方法
* afn提供的方法
    * 直接使用AFNetworkReachabilityManager
    * 通过创建网络中间单例类NetworkTools
* socket实现

三种方法中，只有socket可以实现检测服务器是否可达，具体参考：[Reachability检测网络状态](http://www.cnblogs.com/mddblog/p/5304346.html)
