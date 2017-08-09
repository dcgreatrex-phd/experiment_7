function merge_data_files(subNo)

% Add the function folder to MATLAB path
addpath('./functions/') 

%%
%%%%%%%%%%%%%%%%%%%%%%
% 1 - Define starting variable definitions
%%%%%%%%%%%%%%%%%%%%%%

% 1.1 - Name of the participant folder;
p_folder = strcat('output/P_', num2str(subNo), '/');

% 1.2 - Define input filename and location:
input1 = strcat('exp_1_responses_p_',num2str(subNo),'.txt'); % name of data file to write to
input1 = strcat(p_folder, input1);

% 1.3 - Define second input filename and location:
input2 = strcat('full_generation_',num2str(subNo),'.txt'); % name of data file to write to
input2 = strcat(p_folder, input2);

% 1.4 - Define filename and location of the output .txt result file:
datafilename = strcat('final_results_',num2str(subNo),'.txt'); % name of data file to write to
datafilename = strcat(p_folder, datafilename);                  


%try

    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 2 - Read in the conditions and stimuli locations (from trailfilename.txt
    %%%%%%%%%%%%%%%%%%%%%% 

    % read list of conditions/stimulus images -- textread() is a matlab function
    % objnumber - arbitrary number of stimulus
    % metrical - binary score for metric condition (regular=1, irregular=0)
    % location - binary score for location (left = 0, right = 1);
    % t_before_onset - time in seconds between pretarget and target onset time
    % resp - keyboard response given by participant
    % result - 1 = chose the first option, 2 = chose the second option
    % rt - rt of each response made by the partipant       
    [objnumber, ~, ~, metrical, location, t_before_onset, resp, result, rt] = textread(input1,'%d %d %d %d %d %d %s %d %d');
    ntrials=length(objnumber); 

    % 2.1 - Create an empty cell array ready to be populated by 
    C = cell((ntrials+1), 7);

    % 2.2 - Loop input file into cell array with headings
    counter = 1;
    for trial=1:(ntrials+1); 
        if (counter == 1)
            C{1,1} = 'a_objnumber';
            C{1,2} = 'b_metrical';
            C{1,3} = 'c_location';
            C{1,4} = 't_before_onset';
            C{1,5} = 'resp';
            C{1,6} = 'result';
            C{1,7} = 'rt';
            counter = counter + 1;
        else                
            C{counter, 1} = objnumber(trial-1);
            C{counter, 2} = metrical(trial-1);
            C{counter, 3} = location(trial-1);
            C{counter, 4} = t_before_onset(trial-1);
            C{counter, 5} = resp(trial-1);
            C{counter, 6} = result(trial-1);
            C{counter, 7} = rt(trial-1);
            counter = counter + 1;
        end
    end


    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 3 - Create new dataset with the cell array input
    %%%%%%%%%%%%%%%%%%%%%% 

    % 3.1 - Create dataset
    ds = cell2dataset(C);

    % 3.2 - Sort by number
    ds = sortrows(ds,{'a_objnumber'});

    % 3.3 - Create new dataset with full_generation txt. file information
    ds1 = dataset('File',input2);

    % 3.4 - Join both datasets onto one another
    ds2 = join(ds1, ds, 'Type', 'full', 'MergeKeys',true);

    % 3.5 - Delete unrequired columns
    ds2(:,17) = [];
    ds2(:,17) = [];

    % 3.6 - Export back to the P_folder
    export(ds2,'file',datafilename, 'delimiter','\t');

    % 3.7 - Clear all workspace variables
    clear all

%catch
    
    % write and display error message
%    error = 'There has been an error - Please investigate';
%    disp(error);

    %10.4 - Clear all workspace variables and end the function
%    clear all
%end

end

