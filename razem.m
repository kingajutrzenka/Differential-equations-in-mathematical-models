rValues = [0.05 0.10 0.20 0.30];
n0Values = [5 10 25 50 100 250 500 1000];
kValues = [1000 2000 5000 10000];
t = linspace(0, 200, 500);

f = figure('Name', 'Wykresy funkcji', 'NumberTitle', 'off', ...
    'Position', [100 100 900 700]);

ax1 = axes('Parent', f, 'Position', [0.08 0.58 0.86 0.33]);
grid(ax1, 'on')
hold(ax1, 'on')
xlabel(ax1, 'Czas t')
ylabel(ax1, 'N(t)')
title(ax1, 'N(t) = N_0 e^{rt}')

ax2 = axes('Parent', f, 'Position', [0.08 0.17 0.86 0.33]);
grid(ax2, 'on')
hold(ax2, 'on')
xlabel(ax2, 'Czas t')
ylabel(ax2, 'N(t)')
title(ax2, 'N(t) = 1 / ((1/K) + N_0 e^{-rt})')

rGroup = uibuttongroup(f, 'Title', 'Wybierz r', ...
    'Position', [0.08 0.02 0.52 0.11]);

rButtons = gobjects(numel(rValues), 1);
for idx = 1:numel(rValues)
    xPos = 0.02 + (idx - 1) * 0.24;
    rButtons(idx) = uicontrol(rGroup, 'Style', 'radiobutton', ...
        'Units', 'normalized', ...
        'Position', [xPos 0.18 0.22 0.60], ...
        'String', sprintf('r = %.2f', rValues(idx)), ...
        'UserData', rValues(idx));
end
rGroup.SelectedObject = rButtons(3);

uicontrol(f, 'Style', 'text', 'Position', [610 58 70 20], ...
    'String', 'N_0', 'HorizontalAlignment', 'left');

n0Popup = uicontrol(f, 'Style', 'popupmenu', 'Position', [660 56 140 24], ...
    'String', cellstr(string(n0Values)), ...
    'Value', find(n0Values == 100, 1), ...
    'UserData', n0Values);

uicontrol(f, 'Style', 'text', 'Position', [610 25 70 20], ...
    'String', 'K', 'HorizontalAlignment', 'left');

kPopup = uicontrol(f, 'Style', 'popupmenu', 'Position', [660 23 140 24], ...
    'String', cellstr(string(kValues)), ...
    'Value', find(kValues == 5000, 1), ...
    'UserData', kValues);

p1 = plot(ax1, t, zeros(size(t)), 'LineWidth', 1.8, 'Color', [1 0.4 0.7]);
p2 = plot(ax2, t, zeros(size(t)), 'LineWidth', 1.8, 'Color', [1 0.4 0.7]);

rGroup.SelectionChangedFcn = @(~, ~) updatePlots(ax1, ax2, p1, p2, t, rGroup, n0Popup, kPopup);
n0Popup.Callback = @(~, ~) updatePlots(ax1, ax2, p1, p2, t, rGroup, n0Popup, kPopup);
kPopup.Callback = @(~, ~) updatePlots(ax1, ax2, p1, p2, t, rGroup, n0Popup, kPopup);

updatePlots(ax1, ax2, p1, p2, t, rGroup, n0Popup, kPopup);

function updatePlots(ax1, ax2, p1, p2, t, rGroup, n0Popup, kPopup)
rValues = [0.05 0.10 0.20 0.30];
n0Values = n0Popup.UserData;
kValues = kPopup.UserData;

r = rGroup.SelectedObject.UserData;
n0 = n0Values(n0Popup.Value);
k = kValues(kPopup.Value);

n1 = n0 .* exp(r .* t);
n2 = 1 ./ ((1 ./ k) + n0 .* exp(-r .* t));

p1.YData = n1;
p2.YData = n2;

title(ax1, sprintf('N(t) = N_0 e^{rt}, r = %.2f, N_0 = %d', r, n0))
title(ax2, sprintf('N(t) = 1 / ((1/K) + N_0 e^{-rt}), r = %.2f, N_0 = %d, K = %d', r, n0, k))
end