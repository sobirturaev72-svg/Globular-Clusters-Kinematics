function labels = cluster_display_names(codes)
%CLUSTER_DISPLAY_NAMES Convert canonical codes to publication labels.
codes = string(codes);
labels = strings(size(codes));
for i = 1:numel(codes)
    switch char(codes(i))
        case 'NGC0104', labels(i) = 'NGC 104 (47 Tuc)';
        case 'NGC0362', labels(i) = 'NGC 362';
        case 'NGC1261', labels(i) = 'NGC 1261';
        case 'NGC1851', labels(i) = 'NGC 1851';
        case 'NGC2808', labels(i) = 'NGC 2808';
        case 'NGC5904', labels(i) = 'NGC 5904 (M5)';
        case 'NGC5927', labels(i) = 'NGC 5927';
        case 'NGC5986', labels(i) = 'NGC 5986';
        case 'NGC6205', labels(i) = 'NGC 6205 (M13)';
        case 'NGC6254', labels(i) = 'NGC 6254 (M10)';
        case 'NGC6388', labels(i) = 'NGC 6388';
        case 'NGC6441', labels(i) = 'NGC 6441';
        case 'NGC6541', labels(i) = 'NGC 6541';
        case 'NGC6624', labels(i) = 'NGC 6624';
        case 'NGC6637', labels(i) = 'NGC 6637 (M69)';
        case 'NGC6681', labels(i) = 'NGC 6681 (M70)';
        case 'NGC6715', labels(i) = 'NGC 6715 (M54)';
        case 'NGC6723', labels(i) = 'NGC 6723';
        case 'NGC7078', labels(i) = 'NGC 7078 (M15)';
        case 'NGC7099', labels(i) = 'NGC 7099 (M30)';
        otherwise, labels(i) = codes(i);
    end
end
end
