

function [newpowFcst1 newpowFcst2] = turbineFcst_orthogRegg(DT,Ti)
%clc; clear all ; close all ;

  model='/home/OldData/AnaikadavuSetupAndData/powerModelOutput/00gmt/' ;
  obs='/home/OldData/windpowerFcst/realtimeData/turbineData/' ;
  %cmppath='/home/OldData/windpowerFcst/realtimeData/compiledData/' ;
  fcstpath='/home/OldData/windpowerFcst/reggMethods/orthogReg/' ;
  %DT='20131106' ; Ti='17' ;

fileName=['ATCAK01';'NPRAK09';'NPRAK12';'PTPPP01';'NPRAK10';'NPRAK07';'NPRAK11';'NPRAK08';'NPRAK13';'GALAK09';'GALAK08';...
          'GALAK04';'GALAK16';'TATAK10';'TATAK11';'TATAK13';'TATAK22';'TATAK41';'TATAK45';'TATAK56';'TATAK07';'TATAK28';....
          'TATAK30';'TATAK44';'TATAK23';'TATAK06';'TATAK12';'TATAK31';'TATAK15';'TATAK32';'TATAK51';'TATAK63';'TATAK33';....
          'TATAK24';'TATAK49';'TATAK50';'TATAK47';'TATAK61';'TATAK52';'TATAK53';'TATAK17';'TATAK42';'TATAK38';'TATAK59';'TATAK25';....
          'TATAK46';'TATAK36';'TATAK39';'TATAK55';'TATAK60';'TATAK14';'TATAK19';'TATAK16';'TATAK27';'TATAK02';'TATAK40';'TATAK37';....
          'TATAK21';'TATAK08';'TATAK54';'TATAK48';'TATAK57';'TATAK26';'TATAK43';'TATAK20';'TATAK35';'TATAK18';'TATAK29';'TATAK01';.....	
          'TATAK09';'TATAK05';'TATAK62';'TATAK64';'TATAK58';'TATAK03';'TATAK34';'TATAK65';'TATAK66';'TATAK04';'GALAK01';'GALAK17';.... 
          'GALAK15';'GALAK02';'GALAK14';'GALAK13';'GALAK12';'GALAK06';'GALAK05';'GALAK03';'GALAK10';'GALAK11';'GALAK07'] ;          

 for fl=1:length(fileName)
     
      mFle=[model,DT,'00/',fileName(fl,:),'-',DT,'00.csv'] ;
      oFle=[obs,DT,'/','locsData/',fileName(fl,1:end-2),'-',fileName(fl,end-1:end),'-',DT,'.csv'] ; 
      %cmpFile=[cmppath,DT,'/',fileName(fl,1:end-2),'-',fileName(fl,end-1:end),'-',DT,'.csv'] ;
      fcstFil=[fcstpath,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
      header={'Date,Time' 'Fcst1' 'Fcst2'} ;
     
      
      [cmpData remmodDat]=compile_data(mFle,oFle) ;
      %dlmwrite(cmpFile,cmpData,'delimiter',',')  ;
      
      %Iz=find(cmpData(:,3)) ; cmpDat=cmpData(I,:) ;
       I=gt(cmpData(:,2),0) ; cmpDat=cmpData(I,:) ;
       x=cmpDat(:,2) ; pow1=cmpDat(:,6) ;pow2=cmpDat(:,7) ;
       
       [slp1]= regress_orthols(pow1,x) ;
       [slp2] = regress_orthols(pow2,x) ;
       
       %SLP1(fl,1:2)=slp1 ;
       %SLP2(fl,1:2)=slp2 ;
       
       remPow1=remmodDat(:,4) ; remPow2=remmodDat(:,5) ; remTim=cellstr(datestr(remmodDat(:,1),'yyyy/mm/dd,HH:MM')) ;       
       newpowFcst1=(slp1(1,1)*remPow1)+(slp1(2,1)) ;
       newpowFcst2=(slp2(1,1)*remPow2)+(slp2(2,1)) ;
              
       Fcst=[remTim num2cell([newpowFcst1 newpowFcst2])] ;  
       
       finalFcst=[header;Fcst]   ;              
       cell2csv(fcstFil,finalFcst,',') ;
       clear slp1 ; clear slp2; clear newpowFcst1; clear newpowFcst2 ; clear cmpDat ; clear pow1 ; clear pow2; clear x;
       clear cmpData ; clear remPow1 ; clear remPow2 ; clear remTim ; clear remmodDat ; clear Fcst ;
      
 end
end

  