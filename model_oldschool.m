function [ diagnosis, text_out ] = model_oldschool( age, aggravating, alleviating, comparison, ans_aggravate, ans_alleviate, ans_comparison )

text_out = '';

nflexion = 0;
nextension = 0;
%Find out whether those answers indicate flexion or extension, or both.
for i = 1 : length(ans_aggravate)
    if ans_aggravate(i) == 1
        if strcmp(aggravating{i,2},'flexion') == 1
            nflexion = nflexion + 1;
        elseif strcmp(aggravating{i,2},'extension') == 1
            nextension = nextension + 1;
        else
            nflexion = nflexion + 1;
            nextension = nextension + 1;
        end
    end
end
%Find out whether those answers indicate flexion or extension.
for i = 1 : length(ans_alleviate)
    if ans_alleviate(i) == 1
        if strcmp(alleviating{i,2},'flexion') == 1
            nflexion = nflexion + 1;
        elseif strcmp(alleviating{i,2},'extension') == 1
            nextension = nextension + 1;
        else
            nflexion = nflexion + 1;
            nextension = nextension + 1;
        end
    end
end
%Find out whether those answers indicate flexion or extension, or both.
for i = 1 : length(ans_comparison)
    if ans_comparison(i) == 1
        if strcmp(comparison{i,2},'flexion') == 1
            nflexion = nflexion + 1;
        elseif strcmp(comparison{i,2},'extension') == 1
            nextension = nextension + 1;
        else
            nflexion = nflexion + 1;
            nextension = nextension + 1;
        end
    end
end
ndiff = nflexion - nextension;
if nflexion == 0 && nextension == 0
    text_out = sprintf('%s\n\tYou have indicated that you have no symptoms of flexion or extension biased injuries\n\n', text_out);
    diagnosis = 'null';
else
    text_out = sprintf('%s\n\tYou exhibit %d symptom(s) for flexion and %d symptom(s) for extension.\n', text_out, nflexion, nextension);
    %     disp(numsymptoms)
    if ndiff >= 3 % this indicates an felxion-biased pain
        if ndiff <=4
            text_out = sprintf('%s\n\tYour symptoms are suggestive of a flexion-biased back problem.\n', text_out);
            diagnosis = 'flexion';
        else
            text_out = sprintf('%s\n\tIt is highly probable that you have a flexion-biased back problem.\n', text_out);
            diagnosis = 'flexion';
        end
    elseif ndiff <= -3 % this indicates an extension-biased pain
        if ndiff >= -4
            text_out = sprintf('%s\n\tYour symptoms are suggestive of an extension-biased back problem.\n', text_out);
            diagnosis = 'extension';
        else
            text_out = sprintf('%s\n\tIt is highly probable that you have an extension-biased back problem.\n', text_out);
            diagnosis = 'extension';
        end
    else % this indicates a mixed-bias pain
        if age >= 49
            text_out = sprintf('%s\n\tYou present both flexion and extension biased symptoms.\n\tConsidering your age, %d, you may have a mixed-pattern back pain.\n\tPlease visit Raz\n', text_out, age);
            diagnosis = 'mixed';
        else
            text_out = sprintf('%s\n\tYou present both flexion and extension biased symptoms, suggesting a mixed-pattern back pain.\n\tConsidering your age, %d, it is not likely that you have a mixed pattern back pain.\n\tPlease visit Raz\n', text_out, age);
            diagnosis = 'mixed';
        end
    end
end
if ans_aggravate(7) == 1
    text_out = sprintf('%s\n\n\tIMPORTANT: You indicated that coughing causes aggravation.\n\t--> This is strongly correlated with FLEXION biased injuries\n', text_out);
end
if ans_alleviate(6) == 1
    text_out = sprintf('%s\n\n\tIMPORTANT: You indicated that using a shopping cart alleviates pain.\n\t--> This is strongly correlated with EXTENSION biased injuries\n', text_out);
end
disp('')


end

