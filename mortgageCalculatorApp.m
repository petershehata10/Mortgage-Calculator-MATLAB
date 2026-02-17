function mortgageCalculatorApp
    % Create the main window of the app
    fig = figure('Name', 'Mortgage Calculator', 'NumberTitle', 'off', ...
        'Position', [300, 200, 900, 450]);

    % Loan Amount input
    uicontrol('Style', 'text', 'Position', [50, 380, 120, 20], ...
        'String', 'Loan Amount:', 'HorizontalAlignment', 'left');
    loanAmountEdit = uicontrol('Style', 'edit', 'Position', [180, 380, 150, 25], ...
        'BackgroundColor', 'White');

    % Interest Rate input
    uicontrol('Style', 'text', 'Position', [50, 340, 120, 20], ...
        'String', 'Interest Rate (%):', 'HorizontalAlignment', 'left');
    interestRateEdit = uicontrol('Style', 'edit', 'Position', [180, 340, 150, 25], ...
        'BackgroundColor', 'White');

    % Loan Term input
    uicontrol('Style', 'text', 'Position', [50, 300, 120, 20], ...
        'String', 'Loan Term (Years):', 'HorizontalAlignment', 'left');
    loanTermEdit = uicontrol('Style', 'edit', 'Position', [180, 300, 150, 25], ...
        'BackgroundColor', 'White');

    % Monthly Payment output (disabled edit box)
    uicontrol('Style', 'text', 'Position', [50, 260, 120, 20], ...
        'String', 'Monthly Payment:', 'HorizontalAlignment','left');
    monthlyPaymentText = uicontrol('Style', 'edit', 'Position', [180, 260, 150, 25], ...
        'String', '', 'BackgroundColor', 'White', 'HorizontalAlignment','center', ...
        'Enable','inactive');

    % Button to calculate the mortgage
    uicontrol('Style', 'pushbutton', 'String', 'Calculate', ...
        'Position', [180, 200, 150, 30], 'Callback', @calculateMortgage);
    
    % Button to reset all fields
    uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
        'Position', [180, 160, 150, 30], 'Callback', @resetFields);

    % Create the axes for the plot
    ax = axes('Parent', fig, 'Position', [0.45, 0.2, 0.5, 0.7]);
    grid(ax, 'off');
    title(ax, 'Remaining Balance Over Time');
    xlabel(ax, 'Month Number');
    ylabel(ax, 'Remaining Balance');

    % Function to calculate the mortgage payment and plot the graph
    function calculateMortgage(~, ~)
        % Get values from inputs
        P = str2double(loanAmountEdit.String);
        r = str2double(interestRateEdit.String);
        n = str2double(loanTermEdit.String);

        % Check if inputs are correct
        if isnan(P) || isnan(r) || isnan(n) || P <= 0 || r <= 0 || n <= 0
            errordlg('Please enter valid positive numbers', 'Input Error');
            return;
        end

        % Calculate monthly interest rate and total number of payments
        i = r / (100 * 12); 
        N = n * 12;

        % Formula to calculate monthly payment
        M = P * (i * (1 + i)^N) / ((1 + i)^N - 1);
        % Display result with 2 decimal places
        monthlyPaymentText.String = sprintf('%.2f', M);

        % Calculate remaining balance for each month alone
        balance = zeros(1, N);
        balance(1) = P;
        % Calculate each month by subtracting from balance
        for k = 2:N
            interest = balance(k-1) * i;
            principal = M - interest;
            balance(k) = balance(k-1) - principal;
        end

        % Plot the graph
        cla(ax); % Clear the axes before plotting
        plot(ax, 1:N, balance, 'r*', 'LineWidth', 1);
        title(ax, 'Remaining Balance Over Time');
        xlabel(ax, 'Month Number');
        ylabel(ax, 'Remaining Balance');
        grid(ax, 'on');
    end

    % Function to reset everything
    function resetFields(~, ~)
        loanAmountEdit.String = '';
        interestRateEdit.String = '';
        loanTermEdit.String = '';
        monthlyPaymentText.String = '';
        cla(ax);
        title(ax, 'Remaining Balance Over Time');
        xlabel(ax, 'Month Number');
        ylabel(ax, 'Remaining Balance');
        grid(ax, 'on');
    end
end
