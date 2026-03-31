
sps = 8;  % Сэмплы в символ
beta = 0.35; % Коэф сглаживания
span = 8;
    % Корешковый фильтр
    t = (-span/2:1/sps:span/2).'; % Массив времени
    h = zeros(size(t));

    for k = 1:length(t)
        tk = t(k);

        if abs(tk) < 1e-12
            h(k) = 1 - beta + 4*beta/pi;

        elseif beta > 0 && abs(abs(tk) - 1/(4*beta)) < 1e-12
            h(k) = (beta/sqrt(2)) * (((1 + 2/pi) * sin(pi/(4*beta)) + (1 - 2/pi) * cos(pi/(4*beta))));

        else
            numerator = sin(pi * tk * (1 - beta)) + 4 * beta * tk * cos(pi * tk * (1 + beta));
            denuminator = pi * tk * (1 - (4 * beta * tk)^2);
            h(k) = numerator/denuminator;
        endif
    endfor

    h = h / sqrt(sum(abs(h).^2));
    plot (h);

