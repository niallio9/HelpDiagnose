function [ ans_warning, cancelled ] = warning_signs_gui()

%% initialise
cancelled = 0;

%% some dialogue box options
dlgformat.Interpreter = 'tex';
dlgformat.Default = '';
dlgformat.WindowStyle = 'non-modal';

%% Ask questions related to warning signs
warning off
%Circulatory issue
ans_warning = cell(6, 1);
ans_warning{1} = questdlg('\fontsize{18}If you walk faster, do your symptoms come on sooner?', '', dlgformat);
if strcmp(ans_warning{1}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
%Disease issue
ans_warning{2} = questdlg(sprintf('\\fontsize{18}Do you ongoingly experience any of the following:\n\n\tFevers\n\tNight sweats\n\tChills\n\tUnexplained significant weight loss (~20 lbs or more)'), '', dlgformat);
if strcmp(ans_warning{2}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
%Break/fracture
ans_warning{3} = questdlg('\fontsize{18}Did the pain start after a significant fall or trauma?', '', dlgformat);
if strcmp(ans_warning{3}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
%Osteoporosis
ans_warning{4} = questdlg('\fontsize{18}Do you have a history of osteoporosis?', '', dlgformat);
if strcmp(ans_warning{4}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
%Really bad
ans_warning{5} = questdlg('\fontsize{18}Do you have a significant leakage of a bladder/bowel function that has not been diagnosed by a physician?', '', dlgformat);
if strcmp(ans_warning{5}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
%Cancer
ans_warning{6} = questdlg('\fontsize{18}Do you have a history of prior cancer?', '', dlgformat);
if strcmp(ans_warning{6}, 'Cancel')
    disp('session ended by user')
    out = datetime('now');
    disp(out)
    cancelled = 1;
    return
end
warning on
%
end
