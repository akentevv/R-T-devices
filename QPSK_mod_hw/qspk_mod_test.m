%% Функция для апсемплинга и фильтрации
function filtered_signal = upsample_and_filter(symbols, filter_h, sps)
    % Явная реализация апсемплинга и фильтрации
    % symbols - входные символы
    % filter_h - импульсная характеристика фильтра
    % sps - количество отсчетов на символ

    % Шаг 1: Апсемплинг (вставка нулей)
    N_symbols = length(symbols);
    N_upsampled = N_symbols * sps;
    upsampled = zeros(N_upsampled, 1);
    upsampled(1:sps:end) = symbols;

    % Шаг 2: Фильтрация через свертку
    filtered_signal = conv(upsampled, filter_h, 'full');

    % Опционально: обрезаем края для компенсации задержки фильтра
    % (убираем половину длины фильтра с каждого конца)
    filter_delay = floor(length(filter_h)/2);
    filtered_signal = filtered_signal(filter_delay+1:end-filter_delay);
end
