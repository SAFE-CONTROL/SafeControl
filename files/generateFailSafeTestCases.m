A=perms('aabbcc');
perms_common=cell(0);
for j=1:6
    perms_common=[perms_common; cellstr(unique(A(:,1:j),'rows'))];
end
save('perms_common','perms_common')

A=perms('123456');
perms_trusts=cell(0);
for j=1:6
    perms_trusts=[perms_trusts; cellstr(unique(A(:,1:j),'rows'))];
end
save('perms_trusts','perms_trusts')