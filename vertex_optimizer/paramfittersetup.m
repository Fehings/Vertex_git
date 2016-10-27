function [testShared] = paramfittersetup
testShared = matlab.engine.isEngineShared;

if ~testShared
    matlab.engine.shareEngine('MATLABParamFitter');
end

testShared = matlab.engine.isEngineShared;
end