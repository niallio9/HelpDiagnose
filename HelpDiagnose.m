function [ ] = HelpDiagnose( output_file, model_type )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HelpDiagnose: A test script help diagnose patients with back-pain.    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *INPUT*
%           output_file: STRING - the name of the .txt file to which the
%           patient data will be written. If left empty, the data will be
%           written to 'testout.txt'.
%
%           model_type: STRING - an optional input to choose the type of
%           model to use for aiding in a diagnosis. Possible inputs are:
%               'bayes': uses a naive Bayes' model. (DEFAULT)
%               'forest': uses a random forest model.
%               'old_school': uses hard limits defined by Dr. Awan
%
% *OUTPUT*
%           patient info' and symptoms are written to 'output_file' in the
%           current directory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   NJR

%% set up some defaults
if nargin < 1
    output_file = 'RyanN';
end
fileout = sprintf('%s.txt', output_file);
if nargin < 2
    model_type = 'forest';
elseif ~strcmp(model_type, 'bayes') && ~strcmp(model_type, 'forest') && ~strcmp(model_type, 'old_school')
    error('Invalid model type. Please choose either ''bayes'', ''forest'', or ''old_school''')
end
clc

%% load in the question data
load('Aggravating_symptoms.mat') %Load the information about the activities given by Dr. Awan: (aggravating)
load('Alleviating_symptoms.mat'); %Load the information about the activities given by Dr. Awan: (alleviating)
load('Comparison_symptoms.mat'); %Load the information about the activities given by Dr. Awan: (comparison)
%load('Warnings.mat'); % Load the information about the warning signs given by Dr. Awan (warning)

[ans_aggravate, ans_alleviate, ans_comparison, age ] = get_symptoms_gui( aggravating, alleviating, comparison); %#ok<NODEF>
[ans_warning] = warning_signs_gui();

%% clean and count the data
ans_aggravate = ans_aggravate(2:end);
laggravate = length(ans_aggravate);
aggravating = aggravating(2:end, :);
ans_alleviate = ans_alleviate(2:end);
lalleviate = length(ans_alleviate);
alleviating = alleviating(2:end, :);
ans_comparison = ans_comparison(2:end);
lcomparison = length(ans_comparison);
comparison = comparison(2:end, :);

new_patient_data = double([ans_aggravate', ans_alleviate', ans_comparison']);

%% Assess the results and come up with a diagnosis. These are displayed on the screen.

fid = fopen(fileout,'w');
try
    fprintf(fid, '********************************RESULTS*******************************************');
    switch model_type
        case 'bayes'
            load('model_nb')
            fprintf(fid, '\n\tDecision model: Naive Bayes');
            [diagnosis, ypost, ycost] = predict(Mdl, new_patient_data);
            diagnosis = diagnosis{1};
            fprintf(fid, '\n\tConsidering your information, it is most likely that you have %s-biased back pain', diagnosis);
            
        case 'forest'
            load('model_rf')
            fprintf(fid, '\n\tDecision model: Random Forest');
            [diagnosis, scores, stdevs]= predict(Mdl, [new_patient_data, age]);
            diagnosis = diagnosis{1};
            fprintf(fid, '\n\tConsidering your information, it is most likely that you have %s-biased back pain', diagnosis);
            
        case 'old_school'
            fprintf(fid, '\n\tDecision model: Old-School');
            [diagnosis, text_out] = model_oldschool( age, aggravating, alleviating, comparison, ans_aggravate, ans_alleviate, ans_comparison );
            fprintf(fid, text_out);
    end
    
    %% Warnings
    if strcmp(ans_warning{1}, 'Yes') == 1
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that your symptoms come on sooner if you walk faster.\n\tThis could be indicative of a vascular condition/issue with blood supply\n');
        %     disp(warnout)
    end
    if strcmp(ans_warning{2}, 'Yes') == 1
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that you suffer ongoing Fevers/Night sweats/Chills/Unexplained weight loss.\n\tYour pain may be symptomatic of a serious underlying condition\n');
        %     disp(warnout)
    end
    if strcmp(ans_warning{3}, 'Yes') == 1
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that your symptoms came on after a significant fall/trauma.\n\tThis could mean that you have a fractured or broken bone\n');
        %     disp(warnout)
    end
    if strcmp(ans_warning{4}, 'Yes') == 1 && strcmp(diagnosis, 'flexion')
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that you have a history of osteoporosis.\n\tIn combination with flexion biased symptoms, this could indicate a compression fracture of the spine\n');
        %     disp(warnout)
    end
    if strcmp(ans_warning{5}, 'Yes') == 1
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that you have significant leakage of bladder/bowel function.\n\tIn the context of associated low back pain, this could indicate spinal cord compression\n');
        %     disp(warnout)
    end
    if strcmp(ans_warning{6}, 'Yes') == 1
        fprintf(fid, '\n\tVERY IMPORTANT: You answered that you have a history of prior cancer.\n\tYou may require screening for possible cancer of the bones\n');
        %     disp(warnout)
    end
    % fprintf(fid, '\n\n\t***** See the file "%s" for more detailed information on answered questions *****\n\n',fileout);
    
    %% print out the details of the answered questions
    fprintf(fid, '\n\n******************************DETAILED INFORMATION********************************\n\n');
    fprintf(fid, 'AGE: %d\n\n', age);
    
    fprintf(fid, 'AGGRAVATING ACTIVITIES\n');
    if sum(ans_aggravate) == 0
        fprintf(fid, 'none\n');
    else
        for i = 1: laggravate
            if ans_aggravate(i) == 1
                fprintf(fid, '%s: %s biased\n',aggravating{i, 1},aggravating{i, 2});
            end
        end
    end
    fprintf(fid, '\nALLEVIATING ACTIVITIES\n');
    if sum(ans_alleviate) == 0
        fprintf(fid, 'none\n');
    else
        for i = 1: lalleviate
            if ans_alleviate(i) == 1
                fprintf(fid, '%s: %s biased\n',alleviating{i, 1},alleviating{i, 2});
            end
        end
    end
    fprintf(fid, '\nCOMPARISON OF ACTIVITIES\n');
    if sum(ans_comparison) == 0
        fprintf(fid, 'none\n');
    else
        for i = 1: lcomparison
            if ans_comparison(i) == 1
                fprintf(fid, '%s: %s biased\n',comparison{i, 1}, comparison{i, 2});
            end
        end
    end
    fclose(fid);
    type(fileout)
    fprintf('\n\n\t***** This information has been saved in "%s" *****\n\n', fileout);
catch 
    fclose(fid);
end
%
end
