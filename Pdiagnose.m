function [ Bout, Pout ] = Pdiagnose( model_data, case_data )
%This function calculates the probability of a certain back problem using
% Baye's theorom and the data from previous cases. 
%   Detailed explanation goes here

model = model_data; % the "model" data is the data from the 100 cases
cdata = case_data; % the case data is the information on the case that we want to dignose
sym = model(:,1:28); % take the first 28 columns; they contain the data on symptoms

n = length(model(:,1)); % get the number of cases in the model (100 for now)
s = sum(model(:,1:28)); % get the total number of times each symptom occured
truedat = model(:,31:33); % these are the diagnoses from the doctor for the 100 cases

Pf = sum(truedat(:,1))/100;
Pe = sum(truedat(:,2))/100;
Pm = sum(truedat(:,3))/100;
% 
% % I have set the probability of each diagnosis to be 1/3. This is more
% % realistic of the general population
% Pf = 1/3;
% Pe = 1/3;
% Pm = 1/3;

[I J] = find(s ~= 0); % find the symtoms for which there are no data
sym = sym(:,J); % remove symptoms for which we have no model data
cdata = cdata(J); %reduce the case data like that too

% need to further reduce the symptoms to contain only that which appears in the case data

[Ic, Jc] = find(cdata ~= 0); % find the case data symptoms that have not been answered
sym = sym(:,Jc); % remove them from the model symtoms 
sumsym = sum(sym); % get the total number of appearances of each symptom in the model data
%Psym = prod(sumsym);
psym = sumsym/n; % get the probability of each of those symtoms appearing in the 100 cases
%l = length(J);
%Bdenom = prod(psym); % get the denominator for baye's equation XXX this is wrong...XXX



dummy = 1e-2; % this is a variable set to 0.01. It signifies a probability of 1%
% dummy = 1e-10;
% dummy = 0.333;
%% probability of a flexion bias

[If, Jf] = find(truedat(:,1) == 1); % find the model cases that were diagnosed as flexion
lf = length(If); % get the number of flexion cases
fsym = sym(If,:); % % get the symtoms for each of those flexion cases
fsum = sum(fsym); % get the total number of times each symptom appears in flexion cases
psymf = fsum/lf % get the probability of each symptom appearing in flexion cases
ff = find(psymf == 0); % find the symtoms that have never appeared in flexion cases (probability = 0)
psymf(ff) = dummy; % set the probability of those symptoms to 1% instead of 0% (makes things a little easier)
Psf = prod(psymf); % get the product of the probabilities
Bnumf = Psf*Pf; % multiply that product by the probability of a flexion case: (the numerator for Bayes equation)

%% probability for mixed bias

[Ie, Je] = find(truedat(:,2) == 1); % the comments for extension and mixed cases are similar to the flexion case
esym = sym(Ie,:);
le = length(Ie);
esum = sum(esym);
psyme = esum/le
fe = find(psyme == 0);
psyme(fe) = dummy;
Pse = prod(psyme);
Bnume = Pse*Pe;

%% probability for extension bias

[Im, Jm] = find(truedat(:,3) == 1);
msym = sym(Im,:);
lm = length(Im);
msum = sum(msym);
psymm = msum/lm
fm = find(psymm == 0);
psymm(fm) = dummy;
Psm = prod(psymm);
Bnumm = Psm*Pm;


% final probabilities
Bdenom = Bnumf + Bnume + Bnumm; % the denominator of Bayes equation
Bf = Bnumf/Bdenom; % the probability of each diagnosis: the answer!
Be = Bnume/Bdenom;
Bm = Bnumm/Bdenom;

%% the rest below is just some output and printing and stuff for testing

Bout = [Bf Be Bm]
% Bout = [Bf/.79 Be/.1 Bm/.11]
[~, outi] = max(Bout);
%[~, outi1] = max(Bout1);

Pout = zeros(1,3);
%Pout1 = Pout;
Pout(outi) = 1;
%Pout1(outi1) = 1;

% if Bm >= 0.09
%     Pout1(3) = 1;
% else
%     Pout1 = Pout;
% end

end