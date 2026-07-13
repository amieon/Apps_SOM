%这个文件是哟用于提取出所有数据的前30000条数据
inputFile = 'Part1.csv'; %打开源数据文件
outputFile = 'sample_data.csv'; %输出文件名
opts = detectImportOptions(inputFile, 'Encoding', 'UTF-8'); %使用UTF-8编码
opts.VariableNamingRule = 'preserve'; %保留整个字符串不要化简，比如表头的In-App Purchases，没有这个的话会变成InAppPurchases
vars = {'Rating', 'RatingCount', 'MinimumInstalls', 'MaximumInstalls', ...
'Size', 'Free', 'AdSupported', 'InAppPurchases','Category'};%取这些表头
opts.SelectedVariableNames = vars;
opts.DataLines = [2 30001]; %取前30000条
data = readtable(inputFile, opts);
writetable(data, outputFile);%写到sample_data.csv中
fprintf('成功保持了\n');