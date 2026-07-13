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
