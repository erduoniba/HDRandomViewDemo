### iOS之两圆之间标准圆的随机生成

>相信很多社交产品中，肯定会存在寻找附近人或者附近商家的需求，类似下图，在大圆和小圆之间(橘色区域)生成一系列的随机圆，并且所有随机圆之间也不能有交集，我暂且称这种圆为**标准圆**。
>
>关于这样的需要以前在做项目中有同事做过，虽然可以实现了上面的效果图，但是坐标及半径都是**写死**，从**写死**的数据随机取值，看上去是满足了，但是对于用户来说多次使用该功能时，肯定有一定的视觉疲倦，且写死的一些数据真的不好写，如果大圆或者小圆半径变化了，或者需要更多的**标准圆**，那怎么办呢？一脸懵逼😔

![需求原型](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle.png) 



#### 思路一：

对于这个需求，我一开始也陷入了**写死数据**的套路，但是在兼容大小圆半径上做了一定的兼容，大致的将大圆切分成**9块**，然后在除了中间区域外的**8块**区域再生成一系列的**伪标准圆**。然后取值时现随机选取**8块**区域，再随机从块区拿取**伪标准圆**：

![思路一](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle2.png) 

很明显，在 `1、3、6、8` 块中及中间块 存在很大的误差，明显也不可取



#### 思路二：

根据数学思路，寻找**标准圆**：

1、在大圆内部生成**随机圆1**，也就是生成内含圆：（其中只有圆1才是该步骤所需要的**随机圆1**）

![随机圆1](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle3.png) 

对应的数学公式，当圆心距小于两圆半径之差时 两圆内含: 

大圆中心坐标为（px1、py1），半径为R； 随机圆中心坐标为（px2、py2），半径为r
$$
\sqrt[2]{(px1-px2)^{2} + (py1-py2)^{2}} < R-r
$$
Objective-c代码如下：

```objective-c
// 1: 判断随机生成的 圆 包含在 self 这个大圆内部
if ( sqrt(pow(self.center.x - randomCPX, 2) + pow(self.frame.size.height / 2 - randomCPY, 2)) < (R - r) ) {
	
}
```



2、从第1步得到的**随机圆1**中，筛选出和小圆不相交**随机圆2**:（其中只有圆1才是该步骤所需要的**随机圆2**）

![随机圆2](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle4.png) 

对应的数学公式，当圆心距大于两圆半径之和时 两圆外离: 

小圆中心坐标为（px1、py1），半径为Rr； 随机圆中心坐标为（px2、py2），半径为r
$$
\sqrt[2]{(px1-px2)^{2} + (py1-py2)^{2}} > Rr+r
$$
Objective-c代码如下：

```objective-c
// 2: 判断随机生成的 圆 不在 中间 这个圆 不能重合， 即得到两个圆之间的小圆
if (sqrt(pow(self.center.x - randomCPX, 2) + pow(self.frame.size.height / 2 - randomCPY, 2)) > (Rr + r)) {
	
}
```



3、从第2步得到的**随机圆2**中，筛选出和已存在的**标准圆**不相交**随机圆3**，**随机圆3**即我们所需要的**标准圆**（其中圆2是已经存在的**标准圆**，那么只有圆1才是该步骤所需要的**随机圆3**）

![随机圆3](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle5.png) 

对应的数学公式，当圆心距小于两圆半径之和时 两圆相交或两圆内含，**随机圆2**应该废弃: 

存在的**标准圆**中心坐标为（px、py），半径为rr； 随机圆中心坐标为（px2、py2），半径为r
$$
\sqrt[2]{(px-px2)^{2} + (py-py2)^{2}} \leq rr+r
$$
Objective-c代码如下：

```objective-c
// 3: 新生成的 圆 和已经存在的 圆 不能重合
BOOL success = YES;
for (NSValue *value in randomCircleInfos) {
    CircleInfo circle;
    [value getValue:&circle];
    
    // 只要新生成的 圆 和 任何一个存在的 圆 有交集，则失败
    if (sqrt(pow(circle.center.x - randomCPX, 2) + pow(circle.center.y - randomCPY, 2)) <= (circle.radius + r)) {
        success = NO;
        break ;
    }
}

if (success) {
    [randomCircleInfos addObject:[self standardCircle:randomCPX centerY:randomCPY radius:r]];
}
```

只要通过这三步成功后，即得到了我们所要的**标准圆**，从算法的时间复杂度看 ，得到**标准圆**的复杂度为O(n*n)，对于小量了标准圆来说，速度是非常快的：（当然效率上还由随机圆的半径有关系）

```objective-c
为了寻找 8 个标准圆
一共生成了 53 个随机圆 
生成了 29 个在大圆内部的圆 
生成了 9 个在大圆内部的圆且不与中圆有交集的圆 
  
为了寻找 8 个标准圆
一共生成了 38 个随机圆 
生成了 28 个在大圆内部的圆 
生成了 10 个在大圆内部的圆且不与中圆有交集的圆 
```

但是在产生大量的**标准圆**上，随机生成的总量会非常大：(可以考虑将随机圆半径减少，或者生成该页面之前，提前生成好这些标准圆相关数据：即圆心坐标和半径)

```objective-c
为了寻找 30 个标准圆 
一共生成了 233220 个随机圆 
生成了 138095 个在大圆内部的圆 
生成了 40287 个在大圆内部的圆且不与中圆有交集的圆 
```



最后给出最终成果图：

![最终成果图](http://7xqhx8.com1.z0.glb.clouddn.com/hd_circle_gif.gif) 

对应的log日志：

```objective-c
为了寻找 9 个标准圆 
一共生成了 127 个随机圆 
生成了 75 个在大圆内部的圆 
生成了 20 个在大圆内部的圆且不与中圆有交集的圆

为了寻找 12 个标准圆 
一共生成了 265 个随机圆 
生成了 150 个在大圆内部的圆 
生成了 40 个在大圆内部的圆且不与中圆有交集的圆 

为了寻找 23 个标准圆 
一共生成了 5181 个随机圆 
生成了 3112 个在大圆内部的圆 
生成了 909 个在大圆内部的圆且不与中圆有交集的圆
```



[项目源码地址](https://github.com/erduoniba/HDRandomViewDemo.git) 欢迎 **star** 





