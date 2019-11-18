function [ data_out, age, sym ] = get_casedata( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% fid = fopen('list.txt','w');
% list = dir;
% list = {list.name}';
% for row = 3:length(list)-1;
%     fprintf(fid,'%s\n',list{row,1});
% end
% fclose(fid);

fid = fopen('list.txt');


%% read out some parameters for the naming of files etc.
numlin = 0;

while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        disp('End of list')
        disp(' ');
        break
    end
    disp(tline)
    numlin = numlin + 1;
    filename_list{numlin} = tline;
end
fclose(fid);

max_files = length(filename_list);

data_out = zeros(max_files,33);

load('aggravating13.mat');
load('alleviating8.mat');
load('comparison7.mat');


%% start reading the casefiles

%for n = 1:6
for n = 1:max_files
    
    datain = fopen(filename_list{n});
    
    for i=1:5;
        dummy = fgetl(datain); % first 5 lines are email info
    end
    
    t = fgetl(datain);
    NAME = textscan(t,'%s')
    NAME
    namei = [NAME{1}{2} sprintf(' %s', NAME{1}{3:end})]
    
    t = fgetl(datain);
    AGE = textscan(t,'%s');
    agei = AGE{1}{2};
    age(n,1) = str2num(agei);
    
    dummy = fgetl(datain);
    
    t = fgetl(datain);
    fl_ex = textscan(t,'%s');
    sumflexi = str2num(fl_ex{1}{3});
    sumexi = str2num(fl_ex{1}{8});
    
    t = fgetl(datain);
    
    
    atstar = 0; % decide whther or not you are at the detailed summary line
    
    while atstar == 0;
        if isempty(t) == 1;
            t = fgetl(datain);
        elseif strcmp(t(1:4), '****') == 0
            t = fgetl(datain);
        else
            atstar = 1;
        end
    end
    
    dummy = fgetl(datain);
    dummy = fgetl(datain); % brings me to aggravating symtoms header
    
    endaggravate = 0;
    i=0;
    
    while endaggravate == 0
        
        t = fgetl(datain);
        if isempty(t) == 0
            i=i+1;
            C = textscan(t,'%s');
            sym{i,1} = [C{1}{1} sprintf(' %s', C{1}{2:end-2})]; % get the part of the line that has the symptom
        else
            endaggravate = 1;
        end
    end
    
    dummy = fgetl(datain); % brings me to alleviating symptoms header
    
    endalleviate = 0;
    j=0;
    
    while endalleviate == 0
        
        t = fgetl(datain);
        if isempty(t) == 0
            j=j+1;
            C = textscan(t,'%s');
            sym{i+j,1} = [C{1}{1} sprintf(' %s', C{1}{2:end-2})]; % get the part of the line that has the symptom
        else
            endalleviate = 1;
        end
    end
    
    dummy = fgetl(datain); % brings me to the comparisons header
    
    endcomparison = 0;
    k = 0;
    
    while endcomparison == 0
        
        t = fgetl(datain);
        if isempty(t) == 0
            k=k+1;
            C = textscan(t,'%s');
            sym{i+j+k,1} = [C{1}{1} sprintf(' %s', C{1}{2:end-2})]; % get the part of the line that has the symptom
        else
            endcomparison = 1;
        end
    end
    
    %end
    fclose(datain);
    
    %% now enter the data for case n into the output file
    %i
    %j
    %k
    %sumflexi
    %sumexi
    l_ag = length(aggravating13);
    l_al = length(alleviating8);
    l_com = length(comparison7);
    
    for l = 1:i;
        for f = 1:13
            if strcmp(sym(l),aggravating13(f)) == 1
                data_out(n,f) = 1;
                %else
                %    disp('WARNING: no match')
            end
        end
    end
    
    for l = i+1:i+j;
        for f = 1:8
            if strcmp(sym(l),alleviating8(f)) == 1
                data_out(n,l_ag + f) = 1;
                %else
                %    disp('WARNING: no match')
            end
        end
    end
    
    for l = i+j+1:i+j+k;
        for f = 1:7
            if strcmp(sym(l),comparison7(f)) == 1
                data_out(n,l_ag+l_al+f) = 1;
                %else
                %    disp('WARNING: no match')
            end
        end
    end
    
    data_out(n,29) = sumflexi;
    data_out(n,30) = sumexi;
    difi = sumflexi - sumexi;
    
    if abs(difi) <= 3
        data_out(n,33) = 1;
    elseif difi < -3
        data_out(n,32) = 1;
    elseif difi > 3
        data_out(n,31) = 1;
    end
    
end
end

