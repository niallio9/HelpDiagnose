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
    output_file = 'testout';
end
fileout = sprintf('%s.txt', output_file);
if nargin < 2
    model_type = 'bayes';
elseif ~strcmp(model_type, 'bayes') && ~strcmp(model_type, 'forest') && ~strcmp(model_type, 'old_school')
    error('Invalid model type. Please choose either ''bayes'', ''forest'', or ''old_school''')
end
clc

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
    [age, canceled] = inputsdlg('Please enter your age:', [], [], [], options);
    age = str2double(age{1});
    if isempty(age) == 1 || isnumeric(age) == 0 || isnan(age)
        waitfor(errordlg('You must enter an age to continue', 'Invalid entry'));
    elseif canceled == 1
        disp('session ended by user')
        out = datetime('now');
        disp(out)
        return
    else
        x = 0;
    end
end

%% load in the question data
load('Aggravating_symptoms.mat') %Load the information about the activities given by Dr. Awan: (aggravating)
load('Alleviating_symptoms.mat'); %Load the information about the activities given by Dr. Awan: (alleviating)
load('Comparison_symptoms.mat'); %Load the information about the activities given by Dr. Awan: (comparison)
%load('Warnings.mat'); % Load the information about the warning signs given by Dr. Awan (warning)

totalquestions = length(aggravating) + length(alleviating) + length(comparison) - 3; %#ok<NODEF>
flexion = zeros(totalquestions,1);
extension = zeros(totalquestions,1);

[ans_aggravate, ans_alleviate, ans_comparison ] = get_symptoms_gui( aggravating, alleviating, comparison, options, dlgformat );

% % % %% Get answers to questions about causes of aggravation
% % % [ans_aggravate, canceled]  = inputsdlg(aggravating(:,1), [], aggravating(:,3),[], options); %open checkbox UI
% % % if canceled == 1
% % %     disp('session ended by user')
% % %     out = datetime('now');
% % %     disp(out)
% % %     return
% % % end
% % % ans_aggravate{1} = false; % makes all entries of the same data type
% % % ans_aggravate = cell2mat(ans_aggravate);
% % % 
% % % %% get answers to questions about alleviateing symptoms
% % % x = 1;
% % % while x == 1
% % %     [ans_alleviate, canceled]  = inputsdlg(alleviating(:,1), [], alleviating(:,3), [], options); %open checkbox UI
% % %     if canceled == 1
% % %         disp('session ended by user')
% % %         out = datetime('now');
% % %         disp(out)
% % %         return
% % %     end
% % %     ans_alleviate{1} = false; % makes all entries of the same data type
% % %     ans_alleviate = cell2mat(ans_alleviate);
% % %     %%Check for any contradictions in the aggravating and alleviating
% % %     %%symptoms
% % %     if ans_aggravate(2) == 1 && ans_alleviate(4) == 1
% % %         errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
% % %             aggravating{2,1},alleviating{4,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     elseif ans_aggravate(5) == 1 && ans_alleviate(5) == 1
% % %         errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
% % %             aggravating{5,1},alleviating{5,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     elseif ans_aggravate(6) == 1 && ans_alleviate(3) == 1
% % %         errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
% % %             aggravating{6,1},alleviating{3,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     elseif ans_aggravate(13) == 1 && ans_alleviate(2) == 1
% % %         errorout = sprintf('\\fontsize{18}You have entered "%s" as an aggravating activity and "%s" as an alleviating activity.\nPlease change the alleviating activities or begin again', ...
% % %             aggravating{13,1},alleviating{2,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     else
% % %         x = 0;
% % %     end
% % % end
% % % 
% % % %% Get answers to questions about comparisons
% % % x = 1;
% % % while x == 1
% % %     [ans_comparison, canceled]  = inputsdlg(comparison(:,1), [], comparison(:,3), [], options); %open checkbox UI
% % %     if canceled == 1
% % %         disp('session ended by user')
% % %         out = datetime('now');
% % %         disp(out)
% % %         return
% % %     end
% % %     ans_comparison{1} = false; % makes all entries of the same data type
% % %     ans_comparison = cell2mat(ans_comparison);
% % %     %%Check for any contradictions in the comparison
% % %     if ans_comparison(2) == 1 && ans_comparison(3) == 1
% % %         errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
% % %             comparison{2,1},comparison{3,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     elseif ans_comparison(4) == 1 && ans_comparison(5) == 1
% % %         errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
% % %             comparison{4,1},comparison{5,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     elseif ans_comparison(6) == 1 && ans_comparison(7) == 1
% % %         errorout = sprintf('\\fontsize{18}You have checked "%s" and "%s".\nPlease revise the comparisons or begin again', ...
% % %             comparison{6,1},comparison{7,1});
% % %         waitfor(errordlg(errorout, 'Contradiction', dlgformat));
% % %     else
% % %         x = 0;
% % %     end
% % % end

%% Ask questions related to warning signs
warning off
%Circulatory issue
ans_circulatory = questdlg('\fontsize{18}If you walk faster, do your symptoms come on sooner?', '', dlgformat);
if strcmp(ans_circulatory, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
%Disease issue
ans_disease = questdlg(sprintf('\\fontsize{18}Do you ongoingly experience any of the following:\n\n\tFevers\n\tNight sweats\n\tChills\n\tUnexplained significant weight loss (~20 lbs or more)'), '', dlgformat);
if strcmp(ans_disease, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
%Break/fracture
ans_fracture = questdlg('\fontsize{18}Did the pain start after a significant fall or trauma?', '', dlgformat);
if strcmp(ans_fracture, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
%Osteoporosis
ans_osteo = questdlg('\fontsize{18}Do you have a history of osteoporosis?', '', dlgformat);
if strcmp(ans_osteo, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
%Really bad
ans_bad = questdlg('\fontsize{18}Do you have a significant leakage of a bladder/bowel function that has not been diagnosed by a physician?', '', dlgformat);
if strcmp(ans_bad, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
%Cancer
ans_cancer = questdlg('\fontsize{18}Do you have a history of prior cancer?', '', dlgformat);
if strcmp(ans_cancer, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    return
end
warning on

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

%Find out whether those answers indicate flexion or extension, or both.
for i = 1 : laggravate
    if ans_aggravate(i) == 1
        if strcmp(aggravating{i,2},'flexion') == 1
            flexion(i) = 1;
        elseif strcmp(aggravating{i,2},'extension') == 1
            extension(i) = 1;
        else
            flexion(i) = 1;
            extension(i) = 1;
        end
    end
end
%Find out whether those answers indicate flexion or extension.
for i = 1 : lalleviate
    if ans_alleviate(i) == 1
        if strcmp(alleviating{i,2},'flexion') == 1
            flexion(i+laggravate) = 1;
        elseif strcmp(alleviating{i,2},'extension') == 1
            extension(i+laggravate) = 1;
        end
    end
end
%Find out whether those answers indicate flexion or extension, or both.
for i = 1 : lcomparison
    if ans_comparison(i) == 1
        if strcmp(comparison{i,2},'flexion') == 1
            flexion(i+laggravate+lalleviate) = 1;
        elseif strcmp(comparison{i,2},'extension') == 1
            extension(i+laggravate+lalleviate) = 1;
        end
    end
end
nflexion = sum(flexion);
nextension = sum(extension);
ndiff = nflexion - nextension;



%% Assess the results and come up with a diagnosis. These are displayed on the screen.
disp('********************************RESULTS*******************************************')
%flexion
%extension
switch model_type
    case 'bayes'
        load('model_nb')
        [yfit, ypost, ycost] = predict(Mdl, new_patient_data)
        fprintf('\n\tConsidering your information, it is most likely that you have X-biased back pain')
        
    case 'forest'
        load('model_rf')
        [Yfit,scores,stdevs]= predict(Mdl, new_patient_data);
        fprintf('\n\tConsidering your information, it is most likely that you have X-biased back pain')
        
    case 'old_school'
        if nflexion == 0 && nextension == 0
            fprintf('\n\tYou have indicated that you have no symptoms of flexion or extension biased injuries\n\n');
            %     disp(nosymptoms)
        else
            fprintf('\n\tYou exhibit %d symptom(s) for flexion and %d symptom(s) for extension.\n', nflexion, nextension);
            %     disp(numsymptoms)
            if ndiff >= 3 % this indicates an felxion-biased pain
                if ndiff <=4
                    fprintf('\n\tYour symptoms are suggestive of a flexion-biased back problem.\n');
                else
                    fprintf('\n\tIt is highly probable that you have a flexion-biased back problem.\n');
                end
            elseif ndiff <= -3 % this indicates an extension-biased pain
                if ndiff >= -4
                    fprintf('\n\tYour symptoms are suggestive of an extension-biased back problem.\n');
                else
                    fprintf('\n\tIt is highly probable that you have an extension-biased back problem.\n');
                end
            else % this indicates a mixed-bias pain
                if age >= 49
                    fprintf('\n\tYou present both flexion and extension biased symptoms.\n\tConsidering your age, %d, you may have a mixed-pattern back pain.\n\tPlease visit Raz\n',age);
                else
                    fprintf('\n\tYou present both flexion and extension biased symptoms, suggesting a mixed-pattern back pain.\n\tConsidering your age, %d, it is not likely that you have a mixed pattern back pain.\n\tPlease visit Raz\n',age);
                end
            end
        end
        
        if flexion(7) == 1
            fprintf('\n\tIMPORTANT: You indicated that coughing causes aggravation.\n\t--> This is strongly correlated with FLEXION biased injuries\n');
        end
        if extension(19) == 1
            fprintf('\n\tIMPORTANT: You indicated that using a shopping cart alleviates pain.\n\t--> This is strongly correlated with EXTENSION biased injuries\n');
        end
        disp('')
end

%Warnings
if strcmp(ans_circulatory, 'Yes') == 1
    fprintf('\n\tVERY IMPORTANT: You answered that your symptoms come on sooner if you walk faster.\n\tThis could be indicative of a vascular condition/issue with blood supply\n');
    %     disp(warnout)
end
if strcmp(ans_disease, 'Yes') == 1
    fprintf('\n\tVERY IMPORTANT: You answered that you suffer ongoing Fevers/Night sweats/Chills/Unexplained weight loss.\n\tYour pain may be symptomatic of a serious underlying condition\n');
    %     disp(warnout)
end
if strcmp(ans_fracture, 'Yes') == 1
    fprintf('\n\tVERY IMPORTANT: You answered that your symptoms came on after a significant fall/trauma.\n\tThis could mean that you have a fractured or broken bone\n');
    %     disp(warnout)
end
if strcmp(ans_osteo, 'Yes') == 1 && ndiff >= 3
    fprintf('\n\tVERY IMPORTANT: You answered that you have a history of osteoporosis.\n\tIn combination with flexion biased symptoms, this could indicate a compression fracture of the spine\n');
    %     disp(warnout)
end
if strcmp(ans_bad, 'Yes') == 1
    fprintf('\n\tVERY IMPORTANT: You answered that you have significant leakage of bladder/bowel function.\n\tIn the context of associated low back pain, this could indicate spinal cord compression\n');
    %     disp(warnout)
end
if strcmp(ans_cancer, 'Yes') == 1
    fprintf('\n\tVERY IMPORTANT: You answered that you have a history of prior cancer.\n\tYou may require screening for possible cancer of the bones\n');
    %     disp(warnout)
end

disp('')
fprintf('\n\t***** See the file "%s" for more detailed information on answered questions *****\n\n',fileout);
% disp(seefile)


%% Print a summary of the entered information to the specified output file. This summary is also displayed on screen

fid = fopen(fileout,'w');
fprintf(fid,'******************************DETAILED INFORMATION********************************\n\n');
fprintf(fid,'AGE: %d\n\n',age);

fprintf(fid,'AGGRAVATING ACTIVITIES\n');
if sum(ans_aggravate) == 0
    fprintf(fid,'none\n');
else
    for i = 1:laggravate
        if flexion(i) == 1 || extension(i) == 1
            fprintf(fid,'%s: %s biased\n',aggravating{i,1},aggravating{i,2});
        end
    end
end

fprintf(fid,'\nALLEVIATING ACTIVITIES\n');
if sum(ans_alleviate) == 0
    fprintf(fid,'none\n');
else
    for i = 1 + laggravate: lalleviate + laggravate
        if flexion(i) == 1 || extension(i) == 1
            fprintf(fid,'%s: %s biased\n',alleviating{i-laggravate,1},alleviating{i-laggravate,2});
        end
    end
end

fprintf(fid,'\nCOMPARISON OF ACTIVITIES\n');
if sum(ans_comparison) == 0
    fprintf(fid,'none\n');
else
    for i = 1 + laggravate + lalleviate: lcomparison + laggravate + lalleviate
        if flexion(i) == 1 || extension(i) == 1
            fprintf(fid,'%s: %s biased\n',comparison{i - laggravate - lalleviate, 1}, comparison{i - laggravate - lalleviate, 2});
        end
    end
end
fclose(fid);

fid = fopen(fileout);
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    disp(tline)
end
fclose(fid);

end
