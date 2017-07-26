n=1;
while n<3000
if motionTracker.BytesAvailable>0
tempBuf=fscanf(motionTracker);
out = mat2cell(tempBuf, ones(size(tempBuf,1),1), size(tempBuf,2));
out = strrep(out, 'Y', '');
out2 = cellfun(@str2num, out,'UniformOutput',0);
finFrames(:,:,n)=reshape(out2{1},8,8);
if mod(n,10)==0
    disp(n);
end
n=n+1;
end
end


%%
scaleFac=10;
blurFac=8;
for n=1:size(finFrames,3)
    filtFrames(:,:,n) = imgaussfilt(finFrames(:,:,n),blurFac);
   scaleFrames(:,:,n) =imresize(finFrames(:,:,n),100);
   scaleFiltFrames(:,:,n) = imgaussfilt(scaleFrames(:,:,n),scaleFac*blurFac);
end