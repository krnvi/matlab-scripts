

function [M] = copymodel_Fcst(modFilepath,fcststdt,fcstetdt)

%modFilepath='/home/OldData/AnaikadavuSetupAndData/powerModelOutput/00gmt/2013110600/ATCAK01-2013110600.csv'

modFile=modFilepath ; 
fcstStartdt=fcststdt ;
fcstEnddt=fcstetdt ;

%Reading Data from model file
modelData=read_csv(modFile,',') ; sz=size(modelData) ;
modData=cell2mat(cellfun(@(s) {str2double(s)},modelData(2:sz(1,1),3:5))) ;
moddate=modelData(2:sz(1,1),1); modtim=modelData(2:sz(1,1),2);modWs=(modData(:,1));
modWd=(modData(:,2));modPow1=modData(:,3);modPow2=powerCurve(modWs,1500);

for i=1:length(modData)
    modDate=moddate{i} ; modTim=modtim{i} ;
    DT1{i}=[modDate(1:4) '/' modDate(6:7) '/' modDate(9:10) ' ' modTim] ;
    modat(i,1:5)=[datenum([modDate(1:4) '/' modDate(6:7) '/' modDate(9:10) ' ' modTim]) modWs(i) modWd(i) modPow1(i) modPow2(i)]  ;  
    
end
k=size(modat);

for j=1:length(modat) ;
                 
       if (modat(j,1) >= fcstStartdt) && (modat(j,1) <= fcstEnddt)
       
           M1(j,1:k(1,2))=[modat(j,:)] ;
                                  
      end
end

I=gt(M1(:,1),0) ; M=M1(I,:) ;


end