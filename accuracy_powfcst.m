
function [rowAcc lreggAcc ssAcc] = accuracy_powfcst(DT,Ti)

%clc; clear all ; close all ;

  obs='/home/OldData/windpowerFcst/realtimeData/turbineData/' ;
  fcstPath1='/home/OldData/windpowerFcst/reggMethods/linearReg/' ;
  fcstPath2='/home/OldData/windpowerFcst/reggMethods/smoothSpline/' ;
  
  %DT='20131107' ; Ti='03'
  fcstStdt=datenum([DT(1:4) '/' DT(5:6) '/' DT(7:8) ' ' Ti ':00']) ;
  

fileName=['ATCAK01';'NPRAK09';'NPRAK12';'PTPPP01';'NPRAK10';'NPRAK07';'NPRAK11';'NPRAK08';'NPRAK13';'GALAK09';'GALAK08';...
          'GALAK04';'GALAK16';'TATAK10';'TATAK11';'TATAK13';'TATAK22';'TATAK41';'TATAK45';'TATAK56';'TATAK07';'TATAK28';....
          'TATAK30';'TATAK44';'TATAK23';'TATAK06';'TATAK12';'TATAK31';'TATAK15';'TATAK32';'TATAK51';'TATAK63';'TATAK33';....
          'TATAK24';'TATAK49';'TATAK50';'TATAK47';'TATAK61';'TATAK52';'TATAK53';'TATAK17';'TATAK42';'TATAK38';'TATAK59';'TATAK25';....
          'TATAK46';'TATAK36';'TATAK39';'TATAK55';'TATAK60';'TATAK14';'TATAK19';'TATAK16';'TATAK27';'TATAK02';'TATAK40';'TATAK37';....
          'TATAK21';'TATAK08';'TATAK54';'TATAK48';'TATAK57';'TATAK26';'TATAK43';'TATAK20';'TATAK35';'TATAK18';'TATAK29';'TATAK01';.....	
          'TATAK09';'TATAK05';'TATAK62';'TATAK64';'TATAK58';'TATAK03';'TATAK34';'TATAK65';'TATAK66';'TATAK04';'GALAK01';'GALAK17';.... 
          'GALAK15';'GALAK02';'GALAK14';'GALAK13';'GALAK12';'GALAK06';'GALAK05';'GALAK03';'GALAK10';'GALAK11';'GALAK07';....      
'NSLAK01';'NSLAK04';'NSLAK15';'NSLAK03';'NSLAK05';'NSLAK02';'NSLAK10';'NSLAK09';'NSLAK06';'NSLAK16';'NSLAK08';'NSLAK14';
'NSLAK12';'NSLAK13';'NSLAK17';'NSLAK27';'NSLAK11';'NSLAK07';'NSLAK26';'NSLAK20';'NSLAK31';'NSLAK32';'NSLAK29';'NSLAK23';'NSLAK18';
'NSLAK24';'NSLAK21';'NSLAK19';'NSLAK28';'NSLAK30';'NSLAK25';'NSLAK22';'RSMAK02';'RSMAK01';'SDSAK01';'ITCAK01';'ITCAK05';
'ITCAK03';'ITCAK04';'ITCAK02';'NSLAK33';'ATCAK01'];

        
 for fl=1:1 %length(fileName)
     
      oFle=[obs,DT,'/','locsData/',fileName(fl,1:end-2),'-',fileName(fl,end-1:end),'-',DT,'.csv'] ; 
      fcstFil1=[fcstPath1,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
      fcstFil2=[fcstPath2,DT,'/',Ti,'/',fileName(fl,:),'_',DT,'_',Ti,'00.csv'] ;
        
      
      [obsData fcstData1 fcstData2]=nestedfx1(oFle,fcstFil1,fcstFil2,fcstStdt) ;
           
       x=obsData(:,2) ; lreggPow1=fcstData1(:,2) ;lreggPow2=fcstData1(:,3) ;
       ssPow1=fcstData2(:,2) ; ssPow2=fcstData2(:,3) ;
 end       
end

