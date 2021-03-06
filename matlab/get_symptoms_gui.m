function [ ans_aggravate, ans_alleviate, ans_comparison, age, cancelled ] = get_symptoms_gui( aggravating, alleviating, comparison )

%% initialise
ans_aggravate = [];
ans_alleviate = [];
ans_comparison = [];
age = [];

%% some dialogue box options
options.Resize = 'on';
options.WindowStyle = 'normal';
options.Interpreter = 'tex';
options.FontSize = 18;
options.CancelButton = 'on';

dlgformat.Interpreter = 'tex';
dlgformat.Default = '';
dlgformat.WindowStyle = 'non-modal';

%% Identify the age of the patient
x = 1;
while x == 1
    [age, cancelled] = inputsdlg('Please enter your age:', [], [], [], options);
    age = str2double(age{1});
    if cancelled == 1
        disp('session ended by user')
        out = datetime('now');
        disp(out)
        return
    elseif isempty(age) == 1 || isnumeric(age) == 0 || isnan(age)
        waitfor(errordlg('You must enter an age to continue', 'Invalid entry'));
        
    else
        x = 0;
    end
end

%% Get answers to questions about causes of aggravation
[ans_aggravate, cancelled]  = inputsdlg(aggravating(:,1), [], aggravating(:,3),[], options); %open checkbox UI
if cancelled == 1
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
ans_aggravate{1} = false; % makes all entries of the same data type
ans_aggravate = cell2mat(ans_aggravate);

%% get answers to questions about alleviateing symptoms
x = 1;
while x == 1
    [ans_alleviate, cancelled]  = inputsdlg(alleviating(:,1), [], alleviating(:,3), [], options); %open checkbox UI
    if cancelled == 1
        disp('session ended by user')
        out = datetime('now');
        disp(out)
        return
    end
    ans_alleviate{1} = false; % makes all entries of the same data type
    ans_alleviate = cell2mat(ans_alleviate);
    %%Check for any contradictions in the aggravating and alleviating
    %%symptoms
    if ans_aggravate(2) == 1 && ans_alleviate(4) == 1
        errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
            aggravating{2,1},alleviating{4,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    elseif ans_aggravate(5) == 1 && ans_alleviate(5) == 1
        errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
            aggravating{5,1},alleviating{5,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    elseif ans_aggravate(6) == 1 && ans_alleviate(3) == 1
        errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
            aggravating{6,1},alleviating{3,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    elseif ans_aggravate(13) == 1 && ans_alleviate(2) == 1
        errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
            aggravating{13,1},alleviating{2,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    else
        x = 0;
    end
end

%% Get answers to questions about comparisons
x = 1;
while x == 1
    [ans_comparison, cancelled]  = inputsdlg(comparison(:,1), [], comparison(:,3), [], options); %open checkbox UI
    if cancelled == 1
        disp('session ended by user')
        out = datetime('now');
        disp(out)
        return
    end
    ans_comparison{1} = false; % makes all entries of the same data type
    ans_comparison = cell2mat(ans_comparison);
    %%Check for any contradictions in the comparison
    if ans_comparison(2) == 1 && ans_comparison(3) == 1
        errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
            comparison{2,1},comparison{3,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    elseif ans_comparison(4) == 1 && ans_comparison(5) == 1
        errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
            comparison{4,1},comparison{5,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    elseif ans_comparison(6) == 1 && ans_comparison(7) == 1
        errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
            comparison{6,1},comparison{7,1});
        waitfor(errordlg(errorout, 'Contradiction', dlgformat));
    else
        x = 0;
    end
end

end

