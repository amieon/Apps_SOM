%这个代码是主函数，是神经网络的代码
filename = 'sample_data.csv'; 
data = readtable(filename);
data = preprocess_data(data);%把数据预处理一下

selectedVars = {'Rating', 'RatingCount', 'MinimumInstalls', ...
'MaximumInstalls', 'Size', 'Free', ...
'AdSupported', 'InAppPurchases'};%取这些表头
categoryVars = {'Category'};

data = rmmissing(data); %如果有NaN的话就把他们删了

dataSelected = data(:, selectedVars);
dataCategory = data(:,categoryVars);%为类型专门设置一个数组，等下可以查看聚类是否成功

dataArray = table2array(dataSelected);

dataArray = mapminmax(dataArray', 0, 1); %调用只带的归一化函数

dimension = 48; %48*48维的SOM网络
net = selforgmap([dimension dimension]);
net.trainParam.epochs = 500; 
net = train(net, dataArray);%开始训练

y = net(dataArray);%计算得到每个输入样本激活的神经元
clusterIndex = vec2ind(y); %将激活值 y 转换为每个样本最激活的神经元编号（即“聚类编号”）


%可视化输出聚类结果散点图
figure;
dataArray = dataArray';
gscatter(dataArray(:,1), dataArray(:,2), clusterIndex);
title('聚类结果散点图');
xlabel(selectedVars{1});
ylabel(selectedVars{2});

%下面的代码用于将聚类结果与原数据进行对比
categories = dataCategory.Category(1:length(clusterIndex));%提取对应样本的类别标签

dim1 = net.layers{1}.dimensions(1);%这个方型网络长dim1个神经元
dim2 = net.layers{1}.dimensions(2);%这个方型网络宽dim2个神经元
numNeurons = dim1 * dim2;%一共几个神经元，用于统计每个神经元命中样本数和主要类别

% 初始化 hit count 和类别
hitCounts = zeros(1, numNeurons);%这个数组用于记录某个神经元被击中了几次
categoryMap = strings(1, numNeurons);%这个数组记录某一个神经元 击中样本中最多的那个类型
clusterCats = cell(1, numNeurons);%这个数组是一个二维的数组，用于记录某一个神经元的所以击中类型

%遍历所有的样本，算出某一个神经元被击中了几次
for i = 1:length(clusterIndex)
idx = clusterIndex(i);%这个样本对于神经元的下标
hitCounts(idx) = hitCounts(idx) + 1;%对击中数加一
if ~ismissing(categories(i))
%把这个样本对应类型记录到表示这个神经元下标的数组中，用于后面计算众数
clusterCats{idx}{end+1} = categories{i};%这是第55行，后面有讲到这一行
end
end

%遍历所有神经元，算出该神经元被哪一种类型击中最多次
for i = 1:numNeurons
if ~isempty(clusterCats{i})
%把第55行记录的 这个神经元下标的数组 的所有值进行分类名称（通过categorical），不然字符串不能通过mode计算众数
cats = categorical(clusterCats{i});
categoryMap(i) = string(mode(cats));%使用mode计算众数，再反过来从分类名称转化为字符串
else
categoryMap(i) = "None";%如果没有一个样本命中这个可怜的神经元，就把这个位置赋值为None
end
end

hitGrid = reshape(hitCounts, dim2, dim1)'; %reshape 成二维图像格式
categoryGrid = reshape(categoryMap, dim2, dim1)';%也是reshape，不过是对类型进行reshape


figure;
imagesc(hitGrid); % 用命中数作为颜色背景
colormap(parula); % 选择parula这个颜色
colorbar;
title('SOM节点样本数 + 分类标签');

set(gca, 'YDir', 'normal');%反转y轴，这样就和神经网络的图一样，从右下（0，0）开始递增
% 下面就是叠加类别文本了，把文字打印在figure上面
for i = 1:dim1
for j = 1:dim2
if categoryGrid(i,j) ~= "None"
text(j, i, strrep(categoryGrid(i,j), '_', '\_'), ...
'HorizontalAlignment', 'center', ...
'FontSize', 7, ...
'Color', 'k', ...
'Interpreter', 'none');
end
end
end



function cleanedData = preprocess_data(data)
%下面的这些把软件内存大小变成实数
%比如把 1K -> 1024B 
data.SizeMB = zeros(height(data), 1); 
for i = 1:height(data)
val = data.Size{i};
if endsWith(val, 'M')
data.SizeMB(i) = str2double(erase(val, 'M'));
elseif endsWith(val, 'K')
data.SizeMB(i) = str2double(erase(val, 'K')) / 1024; 
else
data.SizeMB(i) = NaN;%都不对的话就改成NaN，等下我会把这些NaN都删了
end
end
data.Size = []; 
data.Properties.VariableNames{'SizeMB'} = 'Size'; 

%这里把数据的TRUE和FALSE这些布尔值转化成1和0
boolFields = {'Free', 'AdSupported', 'InAppPurchases'};
for i = 1:length(boolFields)
field = boolFields{i};
val = string(data.(field));
data.(field) = double(strcmpi(val, 'TRUE'));
end

cleanedData = rmmissing(data);
end
