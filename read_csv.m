
function data = read_csv(fileName,delimiter)
clear data ; 
fid=fopen(fileName,'r') ;                               %reading file id
lineArray = cell(1000,1);                               %initialise an array                           

  lineIndex = 1;                                        %cell index to place the line 
  nextLine = fgetl(fid);                                %reading data line y line
  while ~isequal(nextLine,-1)                           %Looping till the end of file (last line)          
    lineArray{lineIndex} = nextLine;                    %placing data in an array line by line 
    lineIndex = lineIndex+1;                            %incrementing cell array
    nextLine = fgetl(fid);                              %reading next line
  end
  fclose(fid);                                          %close the file

lineArray = lineArray(1:lineIndex-1) ;                  %removing empty cells from the file

  for iLine = 1:lineIndex-1                             %Looping over lines to seperate different quantities.          
    lineData = textscan(lineArray{iLine},'%s','Delimiter',delimiter); %splitting data according to delimiter 
    lineData = lineData{1};                             %           
    if strcmp(lineArray{iLine}(end),delimiter)                % end of each line            
      lineData{end+1} = '';                     
    end
    data(iLine,1:numel(lineData)) = lineData;       %seperated model data 
  end
end