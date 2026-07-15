function add_xy_errorbars(ax, x, y, xerr, yerr, colour, lineWidth)
%ADD_XY_ERRORBARS Draw symmetric x and y uncertainty bars.
for i = 1:numel(x)
    line(ax, [x(i)-xerr(i), x(i)+xerr(i)], [y(i), y(i)], ...
        'Color', colour, 'LineWidth', lineWidth, 'HandleVisibility', 'off');
    line(ax, [x(i), x(i)], [y(i)-yerr(i), y(i)+yerr(i)], ...
        'Color', colour, 'LineWidth', lineWidth, 'HandleVisibility', 'off');
end
end
