for i=1:size(perms_common,1)
    perm=char(perms_common(i));
    j=findstr(perm,'a');
    if(size(j,2)==1) perm(j(1))='1';
    elseif(size(j,2)==2) perm(j(1))='1'; perm(j(2))='2';
    end
    
    j=findstr(perm,'b');
    if(size(j,2)==1) perm(j(1))='3';
    elseif(size(j,2)==2) perm(j(1))='3'; perm(j(2))='4';
    end
    
    j=findstr(perm,'c');
    if(size(j,2)==1) perm(j(1))='5';
    elseif(size(j,2)==2) perm(j(1))='5'; perm(j(2))='6';
    end
    
    perms_common(i)={perm};
end