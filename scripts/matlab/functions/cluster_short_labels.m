function labels = cluster_short_labels(codes)
%CLUSTER_SHORT_LABELS Compact NGC labels used in the submitted figures.
codes = string(codes);
labels = strings(size(codes));
for i = 1:numel(codes)
    token = regexp(char(codes(i)), '^NGC0*([0-9]+)$', 'tokens', 'once');
    if isempty(token)
        labels(i) = codes(i);
    else
        labels(i) = "NGC " + string(token{1});
    end
end
end
