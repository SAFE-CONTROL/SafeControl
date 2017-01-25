function D = diffTimeSeries(ts)
%
%ts=scenario.failure.communication.packet_receiving.calculators_to_calculators;

dims=size(ts.Data);
nb_dims=length(dims);

if(nb_dims<=2)
    % If data is represented by scalars or vectors, first dimension is used
    % for indexing the timeseries.
    diff_dim=1;
else
    % If data is represented by matrix or tensors, last dimension is used
    % for indexing the timeseries.
    diff_dim=nb_dims;
end

% We verify that the detected dimension for indexing the timeseries is
% correct by comparing the size of this dimension and the number of samples
% in the timeseries
assert(dims(diff_dim)==length(ts.Data));

% We do a differenciation of order 1 and along the indexing dimension.
% Because we don't want 2 differences cancels each other after a summation
% (case of vectors or matrices), we take the absolute value of these
% differences.
diffs=abs(diff(ts.Data,1,diff_dim));

% Preallocation of differenciation vector D
D=zeros(length(ts.Data),1);

if(nb_dims==1)
    %display('case 1: timeseries of scalars');
    D(2:end)=diffs;
elseif(nb_dims==2)
    %display('case 2 : timeseries of vectors');
    temp_diffs=sum(diffs,2);
    for i=1:length(diffs)
        D(i+1)=temp_diffs(i,:);
    end
elseif(nb_dims==3)
    %display('case 3 : timeseries of matrices');
    temp_diffs=sum(diffs,1);
    temp_diffs=sum(temp_diffs,2);
    for i=1:length(diffs)        
        D(i+1)=temp_diffs(:,:,i);
    end
end

% Map values : 0 if 0, 1 else.
D=D~=0;

%plot(D,'o')