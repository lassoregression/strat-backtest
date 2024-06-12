function trading_gui()
    % Create the UI figure and components
    fig = uifigure('Name', 'Trading Strategy Simulator', 'Position', [100 100 800 600]);
    layout = uigridlayout(fig, [4, 1], 'RowHeight', {'1x', '3x', '3x', '1x'});

    % Load Data Button
    loadDataBtn = uibutton(layout, 'Text', 'Load Data', 'ButtonPushedFcn', @(btn, event) loadData());
    loadDataBtn.Layout.Row = 1;
    loadDataBtn.Layout.Column = 1;

    % Start Button
    startBtn = uibutton(layout, 'Text', 'Start Trading', 'ButtonPushedFcn', @(btn, event) startTrading());
    startBtn.Layout.Row = 4;
    startBtn.Layout.Column = 1;

    % Table for displaying current positions and P&L
    pnlTable = uitable(layout);
    pnlTable.Layout.Row = 2;
    pnlTable.Layout.Column = 1;
    pnlTable.ColumnName = {'Symbol', 'Position', 'P&L', 'Entry Price', 'Current Price'};

    % Axes for plotting P&L
    pnlAxes = uiaxes(layout);
    pnlAxes.Layout.Row = 3;
    pnlAxes.Layout.Column = 1;
    title(pnlAxes, 'Profit and Loss');

    % Global structure to store GUI components
    handles = struct('pnlTable', pnlTable, 'pnlAxes', pnlAxes, 'data', [], 'symbols', []);
    fig.UserData = handles;

    function loadData()
        handles = fig.UserData;
        dataPath = '/Users/jeeb/Downloads/Auto_Trading_data/';
        files = dir(fullfile(dataPath, '*.csv')); % Adjust pattern if necessary
        allData = struct();
        for i = 1:numel(files)
            filePath = fullfile(files(i).folder, files(i).name);
            tempData = readtable(filePath);
            symbol = regexp(files(i).name, '^[A-Z]+', 'match', 'once'); % Assumes symbols are at start of filename
            tempData.dateTime = datetime(tempData.dateTime, 'InputFormat', 'yyyyMMdd HH:mm:ss');
            if isfield(allData, symbol)
                allData.(symbol) = [allData.(symbol); tempData];
            else
                allData.(symbol) = tempData;
            end
        end
        handles.data = allData;
        handles.symbols = fieldnames(allData);
        fig.UserData = handles;
        disp('Data loaded successfully.');
    end

    function startTrading()
        handles = fig.UserData;
        symbols = handles.symbols;
        dataStore = handles.data;

        for i = 1:length(symbols)
            symbol = symbols{i};
            data = dataStore.(symbol);
            closePrices = data.close;
            dateTime = data.dateTime;

            [macdSignal, rsiSignal] = computeSignals(closePrices);
            [positions, pnl] = executeTrades(macdSignal, rsiSignal, closePrices);

            % Update the table and plot
            handles.pnlTable.Data = [handles.pnlTable.Data; {symbol, positions(end), pnl(end), closePrices(1), closePrices(end)}];
            plot(handles.pnlAxes, dateTime, pnl);
            hold(handles.pnlAxes, 'on');
        end
        hold(handles.pnlAxes, 'off');
        legend(handles.pnlAxes, handles.symbols);
        fig.UserData = handles;
    end

    function [macdSignal, rsiSignal] = computeSignals(prices)
        [macdLine, signalLine] = macd(prices);
        macdSignal = macdLine > signalLine;

        rsiValues = rsindex(prices);
        rsiSignal = (rsiValues < 30) - (rsiValues > 70);
    end

    function [positions, pnl] = executeTrades(macdSignal, rsiSignal, prices)
        positions = zeros(size(prices));
        for i = 2:length(prices)
            if macdSignal(i) && rsiSignal(i)
                positions(i) = sign(rsiSignal(i)); % 1 for buy, -1 for sell
            end
        end
        pnl = cumsum([0; diff(prices)] .* positions);
    end
end
