我的数据来自于：https://github.com/gauthamp10/Google-Playstore-Dataset.git
可以直接用git clone 下载
对于这个数据集，所有数据合起来有六百多兆

不可能把这些数据都用上，一开始我是全用上的，五分钟连预处理都完成不了，
所有我们必须把数据缩小化，所以我写两个matlab脚本将Part1.csv提取其中的前一万条数据。
在截取数据的同时，我们也同步进行聚类数据选择
我们看一下有几种数据字段：

从左到右分别是：
列号	中文名称	英文名称
1	应用名称	App Name
2	应用 ID	App Id
3	分类	Category
4	评分	Rating
5	评分数量	Rating Count
6	安装量（显示）	Installs
7	安装量（最小值）	Minimum Installs
8	安装量（最大值）	Maximum Installs
9	是否免费	Free
10	价格	Price
11	货币类型	Currency
12	应用大小	Size
13	最低支持安卓版本	Minimum Android
14	开发者 ID	Developer Id
15	开发者网站	Developer Website
16	开发者邮箱	Developer Email
17	上线时间	Released
18	最近更新时间	Last Updated
19	内容分级	Content Rating
20	隐私政策链接	Privacy Policy
21	是否含广告	Ad Supported
22	是否含应用内购买	In App Purchases
23	是否为编辑推荐应用	Editors Choice
24	抓取时间	Scraped Time

像是名字，ID这些字段和聚类无关，所以我们不选他们，只选与聚类有关的：
列号	中文名称	英文名称	说明
4	评分	Rating	用户打分，反应软件好坏
5	评分数量	Rating Count	反映用户参与度
7	安装量（最小值）	Minimum Installs	反映流行程度
8	安装量（最大值）	Maximum Installs	反映流行程度
12	应用大小	Size	反应软件作用（比如游戏会很大，教育类软件会很小）
9	是否免费	Free	反映收费类型
21	是否含广告	Ad Supported	和是否免费配合，反应是否以盈利为目的
22	是否含应用内购买	In App Purchases	和是否有广告，反应是否正大光明盈利

当然还有一条很重要，那就是类别，因为它可以帮我们判断我们的聚类是否准确：
列号	中文名称	英文名称	说明
3	分类	Category	判断聚类准确度



对于SOM拓扑图，所有节点（神经元）间距相等、排列整齐，形成规律的六边形网格，说明网络结构是规则的SOM邻点链接图中每个节点之间的线条与其他6个节点相邻，使用的是六边形拓扑，和SOM拓扑一样，这是网络的默认选项上面这两个图没什么好讲的。 SOM领点距离，SOM采样命中图，SOM输入平面和SOM节点样本数 + 分类标签图要一起看先看一下聚类的效果怎么样，我把邻点距离图分成5份了，我们分别看看这5个部分：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps1.jpg)          对于1部分：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps2.jpg) 可以看出以这个部分以business、education和shopping为主这些软件一般来说都是学校和公司内部使用的，所以评分会很差，内部使用会做的很粗糙从Rating的输入平面图也可以看出来，这里的地方是最浅的![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps3.jpg) 部分1属于上面黄色的部分   对于部分2的上半部分：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps4.jpg) 可以看出Music & Audio 占据了半壁江山，而另外下半部分Book & Reference占据这些软件都比较轻量级，所以都被分到了一起 并且这一部分会以有无内购为标准：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps5.jpg) 部分2全是黑的由于音乐版权，基本所有的音乐都要付钱听，所以音乐软件通过有内购（输入8）聚集在了一起  对于部分2的下半部分：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps6.jpg) 感觉这部分很混乱，什么都有，看不出有什么聚类的痕迹但仔细观察多出来的类型，分别是：education，tool，Personalization，Lifestyle没有entertainment这种大型软件，都是一些小软件这也符合了我们之前的猜想，部分二都是一些轻量级的软件所以这里的所有神经元都是按照size小进行聚类的并且这一部分会以有无内购为标准：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps7.jpg) 部分2全是黑的所以这里颜色最浅（击中数最多）的神经元是都是Personalization个性化，需要进行个性化操作，肯定不会是免费的，需要付钱，所以需要付费的Personalization大量击中同一神经元这也看得出来聚类很成功  对于部分3：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps8.jpg) 这里鱼龙混杂，只要是我们常见的类型，在这里都能见到（但Music&Audio依然多，且聚集在了一起，说明即使鱼龙混杂，也是有秩序的鱼龙混杂，不同的类别还是会聚集在一起）为什么呢，因为不论是什么类型的软件，都有好软件，而聚类到此处的都是Rating高的软件从输入平面图也可以看出来：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps9.jpg) 部分3属于下面黑的部分 对于部分4：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps10.jpg) 出现了大量的bussiness，我没用过商业软件，不知道为什么都聚类到此处了，但他们都聚集在了一起，说明我们的聚类是很成功的。但最高的两项（两个最黄的神经元）却是Education，反而不是business，可能因为这两种类型差不多，但education的类型特征更明显，所以更聚集，导致某些神经元被击中次数过多 ![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps11.jpg) 从hits图中可以看出，这两个神经元被击中的次数是真的多，他俩旁边的business神经元被击中的次数也在30+，我们的聚类太成功了对于部分5：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps12.jpg) 这一部分很长，但是从上到下都差不多，就不想部分2那样分上下部分了，这是我取中间部分的图。这一部分也很鱼龙混杂，但它不像部分3的鱼龙混杂.部分3是热门软件的鱼龙混杂，部分5是冷门软件的鱼龙混杂从他们的聚类类型就可以看出来部分3是education，Personalization，entertainment，Music&Audio，Books&References，都是我们日常所需，也是用的最多的软件部分5是Puzzle，Sports，Action，Racing，Simulation，Adventure，Casual，Card，Strategy，Board，Productivity，Medical说实话，再没看过部分5的时候，我都没想过会有这么多类型，还以为就不到10种类型呢，这部分的类型过于冷门，Adventure，Card，Board这些我看英文我都不知道他们是干什么的      ![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps13.jpg) ![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps14.jpg) 并且这一部分既无内购（输入7），又无广告（输入8），还免费（输入6)属于是创作者们对自己小众兴趣的热爱，做出了这些冷门软件正因如此，他们的下载量肯定也少点可怜，所以都被聚类到此处了  





分两部分，一部分是数据处理，另一部分是网络图像研究对于数据处理遇到的问题是输入数据无法使用，发现是有一些软件会出现错误字段，比如有的地方应该填数字，但是它却填成了布尔值，让我的预处理函数直接崩溃了![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps15.jpg)像这样，该填TRUE的地方填成了0，该填0的地方填成了TRUEGithub上下载的数据居然会出错，我太信任其他人了所以我在预处理函数中加上了判断，如果出错，就填上NaN，然后统一删除![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps16.jpg)  并且我仅通过这六张图（SOM拓扑，SOM邻点链接，SOM邻点距离，SOM输入平面，SOM采样命中率，SOM权重位置），根本没办法直观的看出聚类是否成功。所以我要想办法来证明聚类成功，聚类——把同一类型的事务聚集在一起，刚好我这表格有一个类型字段，所以我就以这一字段来判断我的聚类是否成功。所以我又建了一张图，用于表示每个神经元最多击中的类型，这样再和SOM邻点距离配合就可以直观的看出聚类是否成功了。建这一张耗费了我大量时间，但是它既要遍历所有样本，有要遍历所有神经元，两次遍历之间相互交织。让我每一个神经元的细节，样本与神经元的关系，更加深刻的理解了SOM网络。 对于网络图像研究在上课的时候，老师的网络是8*8的，并且样本少，根本无法直观的看出这些表是干什么的并且上课时思考时间短，就更难以理解了 尤其是对于邻点距离图，一点也不直观![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps17.jpg) 老师上课给的样例的聚类的图，看不出有聚类分块而我的图因为神经元多，可以明显的看到出来分了几块，分了哪几部分：  ![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps18.jpg)我一看我这个，瞬间就理解聚类的思想了 并且我这个图还能很好的与其他图联动，理解了图与图之间的关系；下面是我对命中图的分化，在命中数为空的连续区域画线，就出现了和距离图一样的形状这就是命中图和距离图的联动，在小SOM网络难以看出来，在大SOM网络就很明显![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps19.jpg) 当然对于输入平面图也一样他们的颜色变化范围都和距离图的范围差不多，每一张图都联系紧密：![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps20.jpg)![img](file:///C:\Users\ASUS\AppData\Local\Temp\ksohtml27772\wps21.jpg) 也了解到了怎么看这些图：SOM邻点距离图，可视化神经元之间的距离，常用于识别类与类之间的边界。颜色越深表示神经元之间的距离越远（即聚类边界)，颜色浅则表示类内部。 SOM采样命中率图展示每个神经元上被分配了多少个样本。数字或颜色代表样本数量；颜色深表示样本多，是热门聚类中心。 SOM输入平面图分别显示每个输入特征在整个网络上的分布。每一张图对应一个特征，比如 "评分"、"下载量"，颜色深浅表示该特征值的大小。用来判断某个特征是否在某个聚类区域内更占主导。 SOM权重位置图将高维空间中的神经元权重映射到二维空间，展示其分布结构。显示所有神经元在输入特征空间中的权重中心，可以判断聚类的分布密度与散布范围。


