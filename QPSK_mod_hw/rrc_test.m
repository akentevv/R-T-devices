beta = 0.35; % Коэф сглаживания
span = 8;
sps = 8;  % Сэмплы в символ

rrc = rrc_filter(beta, span, sps);

plot (rrc);
