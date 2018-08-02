function saveDataSPMD(fileDir, fileName, data)
  
  if exist(fileDir, 'file') ~= 7
    mkdir(fileDir);
  end
  outPath = sprintf('%s%s', fileDir, fileName,'-v7.3');
  psave(outPath, 'data');
  
end