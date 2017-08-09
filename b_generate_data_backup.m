function b_generate_data_backup(subNo)

% Add the function folder to MATLAB path
addpath('./functions/') 


%%
%%%%%%%%%%%%%%%%%%%%%%
% 1 - Define starting variable definitions
%%%%%%%%%%%%%%%%%%%%%%

% 1.1 Name of the participant folder;
p_folder = strcat('output/P_', num2str(subNo), '/');

% 1.2 Location of the input prevalues                       
input = strcat(p_folder, 'p_prevalues_', num2str(subNo), '.txt');

% 1.3 define name of both output files from the generation
exp_name1 = 'full_generation_';
exp_name2 = 'reduced_generation_';


%%
%%%%%%%%%%%%%%%%%%%%%%
% 2 - file handling definitions
%%%%%%%%%%%%%%%%%%%%%%

% define filename and location of the output .txt result file:
datafilename1 = strcat(exp_name1,num2str(subNo),'.txt'); % name of data file to write to
datafilename1 = strcat(p_folder, datafilename1);                  

% define filename and location of the output .txt result file:
datafilename2 = strcat(exp_name2,num2str(subNo),'.txt'); % name of data file to write to
datafilename2 = strcat(p_folder, datafilename2);   

try
    %%
    %%%%%%%%%%%%%%%%%%%%%%
    % 3 - Read in the conditions and stimuli locations (from input)
    %%%%%%%%%%%%%%%%%%%%%% 

    % read list of conditions/stimulus images -- textread() is a matlab function
    % objnumber  arbitrary number of stimulus
    % filename1 - name of the file name
    % genre - Type of genre associated with filename1
    % key - key response given by the participant
    % value - valuation score given by participant
    % rt - rt of each response made by the partipant       
    [objnumber, filename1, soundname1, genre, ~, famil, ~, ~, value, ~, ~, ~] = textread(input,'%d %s %s %s %s %d %d %s %d %d %d %d');
    ntrials=length(objnumber); 

    % 3.1 - Create an empty cell array ready to be populated by 
    C = cell((ntrials+1), 6);

    % 3.2 - Loop through data and associated to a cell array
    counter = 1;
    for trial=1:(ntrials+1); 
        if (counter == 1)
            C{1,1} = 'number';
            C{1,2} = 'b_filename';
            C{1,3} = 'c_soundname';
            C{1,4} = 'd_genre';
            C{1,5} = 'e_value'; 
            C{1,6} = 'f_famil';
            counter = counter + 1;
        else                
            C{counter, 1} = objnumber(trial-1);
            C{counter, 2} = filename1(trial-1);
            C{counter, 3} = soundname1(trial-1);
            C{counter, 4} = genre(trial-1);
            C{counter, 5} = value(trial-1);
            C{counter, 6} = famil(trial-1);
            counter = counter + 1;
        end
    end

    % 3.2 - Sort cell array by the first column to order the file names
    obnumber = sortrows(objnumber,1);

    % 3.3 - Create an element wise array replication and then invert the matrix
    % http://stackoverflow.com/questions/1947889/element-wise-array-replication-in-matlab
    array = 1:ntrials;
    list1 = kron(array,ones(1,ntrials));
    list1 = (list1');

    % 3.4 - Create repeating list of trial numbers
    list2 = repmat(obnumber, ntrials, 1);

    % 3.5 - Merge both list arrays into one final lookup matrix.
    finallist = [list1,list2];

    % 3.6.1 - Loop through the final list and remove any instances with duplicated values
    % http://www.mathworks.com/matlabcentral/answers/105768-how-can-i-delete-certain-rows-of-a-matrix-based-on-specific-column-values
    for n = 1:size(finallist,1);
        if finallist(n, 1) == finallist(n,2)
            deleterows(n) = true;
        end        
    end

    % 3.6.2 - Delete rows
    finallist(deleterows, :) = [];

    
    
    %
    %%%%%%%%%%%%%%%%%%%%%
    % 4 - Create dataset 1
    %%%%%%%%%%%%%%%%%%%%% 

    % 4.1 - Create dataset
    ds = cell2dataset(C);

    % 4.2 - Sort by number
    ds = sortrows(ds,{'number'});

    
    %%%%%%%%%%%%%%%%%%%%%
    % 5 - Create dataset 2
    %%%%%%%%%%%%%%%%%%%%% 

    % 5.1 - Create second dataset
    ds2 = mat2dataset(finallist);
    ds2.Properties.VarNames{1} = 'number';

    % 5.2 - Join both databases on the relevant keys and rename in order to get the final combination list
    ds3 = join(ds2,ds, 'Type', 'full', 'MergeKeys',true);
    ds3.Properties.VarNames{1} = 'no_1';
    ds3.Properties.VarNames{2} = 'number';
    ds3.Properties.VarNames{3} = 'g_filename1';
    ds3.Properties.VarNames{4} = 'h_soundname1';
    ds3.Properties.VarNames{5} = 'i_genre1';
    ds3.Properties.VarNames{6} = 'j_value1';
    ds3.Properties.VarNames{7} = 'k_famil1';
    ds4 = join(ds, ds3, 'Type', 'full', 'MergeKeys',true);

 
    % 5.3 - Delete unrequired columns
    ds4(:,1) = [];
    ds4(:,6) = [];

    
    
    %%%%%%%%%%%%%%%%%%%%%
    % 6 - Add randomisation
    %%%%%%%%%%%%%%%%%%%%%

    % 6.3.1 - Remove any rows where the individual value = 0;
    for i = 1:size(ds4,1);
       if  ds4.e_value(i) == 0 || ds4.j_value1(i) == 0; 
           ds4.flag(i) = 1;
           delete(i)=true;
       else
           ds4.flag(i) = 0;
           delete(i)=false;
       end 
    end

    if ismember(1,delete)
        ds4(delete, :) = [];
    end

    % 6.3.2 - Remove any rows where the individual familiar is less than 3;
    for i = 1:size(ds4,1);
       if  ds4.f_famil(i) <= 3 || ds4.k_famil1(i) <= 3; 
           ds4.flag(i) = 1;
           delete2(i)=true;
       else
           ds4.flag(i) = 0;
           delete2(i)=false;
       end 
    end

    if ismember(1,delete2)
        ds4(delete2, :) = [];
    end
    
    % 6.3.2 - Remove flag column;
    ds4(:,11) = [];

    %
    %%%%%%%%%%%%%%%%%%%%%
    % 7 - Generate total valuation column
    %%%%%%%%%%%%%%%%%%%%%

    % 7.1 - Generate a total value left-right value scores. Append onto datatable
    ds4.l_difference = ds4.e_value - ds4.j_value1;
    
    
    % 7.1.1 - Remove any rows where the difference is less than -2 and greater than +2;
    for i = 1:size(ds4,1);
       if  ds4.l_difference(i) < (-2) || ds4.l_difference(i) > (2); 
           ds4.flag(i) = 1;
           delete3(i)=true;
       else
           ds4.flag(i) = 0;
           delete3(i)=false;
       end 
    end

    if ismember(1,delete3)
        ds4(delete3, :) = [];
    end

    
    % 7.2 - Remove flag column;
    ds4(:,12) = [];
    
    
    % 7.5 - Sort data table assending on total value scores.
    ds4 = sortrows(ds4,{'l_difference'},{'descend'});
    
    
    
    
    % 7.6 - Add a new difference variable which removes the signs
    zero_counter = 5;
    
    ds4.Properties.VarNames{11} = 'l_difference_a';
        
    for i = 1:size(ds4,1);
       if  ds4.l_difference_a(i) == 0; 
           ds4.l_difference(i) = zero_counter;
           if zero_counter == 5;
               zero_counter = -5;
           else
               zero_counter = 5;
           end  
       else
           ds4.l_difference(i) = ds4.l_difference_a(i);         
       end 
    end
    
    % 7.3 - Randomise the rows
    shuffle = randperm(size(ds4))';

    % 7.4 - Join back onto original dataset
    ds4.randomno = shuffle;

    % 7.5 - Sort data table assending on total value scores.
    ds4 = sortrows(ds4,{'l_difference','randomno'},{'descend','ascend'});
  
    %%% NOTE 5 is being used to represent 0 in the difference variable %%


    %
    %%%%%%%%%%%%%%%%%%%%%
    % 8 - Prepare new dataset for export
    %%%%%%%%%%%%%%%%%%%%%

    % 8.0 - Create final dataset for export
    ds5 = ds4;

     
    % 8.1 - Delete unrequired random column
    ds5(:,13) = [];

    % 8.2 - Create the 50% 50% fixation weight variable by looping through
    % variables depending on sign of difference score
    for i = 1:size(ds5,1);
       if ds5.l_difference(i) < 0;
           ds5.m_fixation_w(i) = 0;
       elseif ds5.l_difference(i) > 0;        
           ds5.m_fixation_w(i) = 1;
       else
           ds5.m_fixation_w(i) = '';
       end
    end 
    
    % 8.3 - Create the 50% 50% metric variable by looping through binary values
    counter = 1;
    for i = 1:size(ds5,1);
       if counter == 1; 
       ds5.n_metric(i) = counter; 
       counter = counter - 1; 
       else       
       ds5.n_metric(i) = counter;
       counter = counter + 1;  
       end
    end    
   
    ds5 = sortrows(ds5,{'l_difference','n_metric'},{'descend','ascend'});
    
    % 8.4 - Create the 50% 50% direction variable by looping through binary values
    counter = 0;
    for i = 1:size(ds5,1);
       if counter == 0; 
       ds5.o_location(i) = counter; 
       counter = counter + 1; 
       else       
       ds5.o_location(i) = counter;
       counter = counter - 1;  
       end
    end
    
    % 8.5 - Sort data into the correct format
    ds5 = ds5(:, sort(ds5.Properties.VarNames) ); 

%     
    % 8.6 - assign unquie key to every condition combination;
    for i = 1:size(ds5,1);
       if  ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -5 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0; 
           ds5.p_condition_id(i) = 1;
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -5 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 2; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -5 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0; 
           ds5.p_condition_id(i) = 3; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -5 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 4; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -1 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 5; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -1 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 6;
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -1 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 7; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -1 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 8; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -2 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 9; 
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -2 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 10;
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -2 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 11;
       elseif ds5.m_fixation_w(i) == 0 && ds5.l_difference(i) == -2 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 12;  
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 5 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0; 
           ds5.p_condition_id(i) = 13;
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 5 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 14; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 5 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0; 
           ds5.p_condition_id(i) = 15; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 5 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 16; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 1 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 17; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 1 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 18;
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 1 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 19; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 1 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 20; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 2 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 21; 
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 2 && ds5.n_metric(i) == 0 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 22;
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 2 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 0;
           ds5.p_condition_id(i) = 23;
       elseif ds5.m_fixation_w(i) == 1 && ds5.l_difference(i) == 2 && ds5.n_metric(i) == 1 && ds5.o_location(i) == 1;
           ds5.p_condition_id(i) = 24;    
       end 
    end


    ds5 = sortrows(ds5,{'p_condition_id'},{'ascend'});

    
    
    % 8.7.1 - Reassign zero to both 5 and -5 of difference scores
    for i = 1:size(ds5,1);
        if ds5.l_difference(i) == 5 || ds5.l_difference(i) == -5;
            ds5.l_difference(i) = 0;
        else
            ds5.l_difference(i) = ds5.l_difference(i);
        end 
    end
    
    % 8.7.2 - Reassign zero to both 5 and -5 of difference scores
    for i = 1:size(ds5,1);
        if ds5.l_difference(i) == -1;
            ds5.l_difference(i) = 1;
        else
            ds5.l_difference(i) = ds5.l_difference(i);
        end 
    end
    
    % 8.7.3 - Reassign zero to both 5 and -5 of difference scores
    for i = 1:size(ds5,1);
        if ds5.l_difference(i) == -2;
            ds5.l_difference(i) = 2;
        else
            ds5.l_difference(i) = ds5.l_difference(i);
        end 
    end
    
    
    %
    %%%%%%%%%%%%%%%%%%%%%
    % 9 - Prepare new dataset for export
    %%%%%%%%%%%%%%%%%%%%%
    
    % 9.1 - Create dynamic count column in cell array.
    conditionid = ds5.p_condition_id;

    % 9.2 - Open new cell array 
    E = cell((size(ds5,1)+1), 2);

    % 9.3 - Loop total score into new cell array and generate dynamic count
    counter = 1;
    for i = 1:size(E,1);
        if i == 1;
            E{1,1} = 'p_condition_id';
            E{1,2} = 'q_block_no';
        elseif i == 2;
            E{i,1} = conditionid(i-1);
            E{i,2} = counter;
            counter = counter + 1;    
        elseif i>2 && conditionid(i-1) == conditionid(i-2);    
            E{i,1} = conditionid(i-1);
            E{i,2} = counter;
            counter = counter + 1;
        else
            counter = 1;
            E{i,1} = conditionid(i-1);
            E{i,2} = counter;   
            counter = counter + 1;
        end        
    end

    
    % 9.4 - Create back into a dataset
    dsE = cell2dataset(E);

    % 9.5 - Join new dataset back onto original dataset
    ds5.q_block_no = dsE.q_block_no;
    
    % 9.6 - Sort data
    ds5 = sortrows(ds5,{'q_block_no', 'p_condition_id'},{'ascend','descend'});

    
    % 9.7.1 - Create the objnumber variable for the experimental run
    % objnumber = (1:no_trials)';
    objnumber = (1:size(ds5,1))';   
 
    % 9.7.2 - join this variable to ds5
    ds5.a_objnumber = objnumber;   
        
    % 9.7.3 - Sort data into the correct format
    ds5 = ds5(:, sort(ds5.Properties.VarNames) ); 
    
    
    % 9.8 - find all complete blocks, flag each valid row/
    for i = 1:size(ds5,1);
        ds5.unique_valid(i) = 1;
    end      
    
    for i = 1:size(ds5,1);
       if  ds5.p_condition_id(i) == 1 && ds5.p_condition_id(i+1) ~= 24; 
           ds5.unique_valid(i+1) = 0;
       end 
    end
    
    for i = 1:size(ds5,1);
       if  ds5.unique_valid(i) == 0; 
           ds5.unique_valid(i+1) = 0;
       end 
    end
    
    % 9.8.2 - Flag and remove any incomplete block rows
    for i = 1:size(ds5,1);
       if  ds5.unique_valid(i) == (0); 
           ds5.flag(i) = 1;
           delete4(i)=true;
       else
           ds5.flag(i) = 0;
           delete4(i)=false;
       end 
    end

    if ismember(1,delete4)
        ds5(delete4, :) = [];
    end

    % 9.8.3 - Remove unique valid and flag variables;
    ds5(:,19) = [];
    ds5(:,19) = [];

    % 9.8.4 - Add random column and sort within block
    shuffle2 = randperm(size(ds5))';

    % 9.8.5 - Join back onto original dataset
    ds5.randomno2 = shuffle2;
      
    % 9.8.6 - Sort data table assending on total value scores.
    ds5 = sortrows(ds5,{'q_block_no','randomno2'},{'ascend','ascend'});
    
    % 9.9.4 - Remove randonno2 colum;
    ds5(:,19) = [];    

    
    
    
    %%%%%%%%%%%%%%%%%%%%%
    % 10 - Prepare reduced dataset for export and experimental input
    %%%%%%%%%%%%%%%%%%%%%

    % 10.1 - Create reduced dataset generation of experimental input
    ds6 = ds5;
    ds6(:,4) = [];
    ds6(:,4) = [];
    ds6(:,4) = [];
    ds6(:,6) = [];
    ds6(:,6) = [];
    ds6(:,6) = [];
    ds6(:,6) = [];
    ds6(:,6) = [];
    ds6(:,6) = [];

    % 10.2 - Sort data into the correct format
    ds6 = ds6(:, sort(ds6.Properties.VarNames) ); 

    % 10.3 - Export both full and reduced datasets to the p_folder
    export(ds5,'file',datafilename1, 'delimiter','\t');
    export(ds6,'file',datafilename2, 'delimiter','\t', 'WriteVarNames',false);
    
    % Write and display summary message regarding the output
    summary = 'Number of complete blocks created:';
    disp(summary);
    
    maxcount = 1;
    for i = 1:size(ds5,1);
       if  ds5.q_block_no(i) > maxcount; 
           maxcount = maxcount + 1;
       end 
    end    
    disp(maxcount);

    % 10.4 - Clear all workspace variables and end the function
    clear all

catch

    %Write and display error message
    error = 'There are not enough rows in ds5 to create the desired number requested in no_trials input';
    disp(error);

    %10.4 - Clear all workspace variables and end the function
    clear all

end


%end





























