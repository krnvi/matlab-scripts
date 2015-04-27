

function [M N] = compile_data(modFilepath,obsFilepath,fcststdt,fcstetdt)

%modFilepath='/home/OldData/AnaikadavuSetupAndData/powerModelOutput/00gmt/2013110600/ATCAK01-2013110600.csv'
%obsFilepath='/home/OldData/windpowerFcst/realtimeData/turbineData/20131106/locsData/ATCAK-01-20131106.csv'

modFile=modFilepath ; 
obsFile=obsFilepath ;
fcstStartdt=fcststdt ;
fcstEnddt=fcstetdt ;

%Reading Data from model file
modelData=read_csv(modFile,',') ;
sz=size(modelData) ;
modData=cell2mat(cellfun(@(s) {str2double(s)},modelData(2:sz(1,1),3:5))) ;
moddate=modelData(2:sz(1,1),1); modtim=modelData(2:sz(1,1),2);modWs=(modData(:,1));
modWd=(modData(:,2));modPow1=modData(:,3);modPow2=powerCurve(modWs,1500);

for i=1:length(modData)
    modDate=moddate{i} ; modTim=modtim{i} ;
    DT1{i}=[modDate(1:4) '/' modDate(6:7) '/' modDate(9:10) ' ' modTim] ;
    modat(i,1:5)=[datenum([modDate(1:4) '/' modDate(6:7) '/' modDate(9:10) ' ' modTim]) modWs(i) modWd(i) modPow1(i) modPow2(i)]  ;  
    
end

%Reading Data from Obs file
obsData=read_csv(obsFile,',') ;
oz=size(obsData) ;
obData=cell2mat(cellfun(@(s) {str2double(s)},obsData(:,3:4))) ;
obsdate=obsData(:,1);obstim=obsData(:,2);obsPow=obData(:,1);tbstat=obData(:,2); 

for i=1:length(obsData)
      
    obsDate=obsdate{i} ; obsTim=obstim{i} ;
    DT2{i}=[obsDate(1:4) '/' obsDate(5:6) '/' obsDate(7:8) ' ' obsTim ] ;
    obdat(i,1:3)=[datenum([obsDate(1:4) '/' obsDate(5:6) '/' obsDate(7:8) ' ' obsTim]) obsPow(i) tbstat(i)] ;  
    
end


oz=size(obdat) ; mz=size(modat) ; k=((oz(1,2))+(mz(1,2)-1));


for i=1:length(obdat) 
    
    for j=1:length(modat) 
        
           if (obdat(i,1) == modat(j,1)) && (obdat(i,1) <= fcstStartdt)
               idx(i,1:2)=[i j] ;
              M(i,1:k)=[obdat(i,:) modat(j,2:end)] ;
                           
           end        
        
    end
 
end
for j=1:length(modat) ;
                 
       if (modat(j,1) >= fcstStartdt) && (modat(j,1) <= fcstEnddt)
       
           M1(j,1:mz(1,2))=[modat(j,:)] ;
                                  
      end
end

I=gt(M1(:,1),0) ; N=M1(I,:) ;

%for i=1:length(modat) 
    
        %if (fcstStartdt == modat(i,1))
            %modIndx=i ;
       % end
        
%end
       
     % remmodIndx=[modIndx modIndx+25] ;
     % N=modat(remmodIndx(1,1):remmodIndx(1,2),:) ;        


end











  