%% Specify Paths
home = pwd;
paths = [convertCharsToStrings(fullfile(pwd,'Optimization'));
    convertCharsToStrings(fullfile(pwd,'Simulator'));
    convertCharsToStrings(fullfile(pwd,'Tools'))];


%% Add All Paths
for i = 1:length(paths)
    addpath(paths(i,:));
end

%% Clean Up
cd(home);
clear paths home