function dispTestCases(test_case)

m=size(test_case,1);

for i=1:m
    display(['Test case ' num2str(i) ' :']);
    test_case(i,:,:)
end