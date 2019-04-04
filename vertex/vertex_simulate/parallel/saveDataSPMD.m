function saveDataSPMD(fileDir, fileName, data)
  
  if exist(fileDir, 'file') ~= 7
    mkdir(fileDir);
  end
  outPath = sprintf('%s%s', fileDir, fileName);
  psave(outPath, 'data','-v7.3');
  
end