function assertFileExists(name)

if(evalin('base',['exist(''' name ''')==1']))
    display(['File ''' name ''' is shadowed by a variable : clearing it...']);
    evalin('base',['clearvars ' name]);
    assert(evalin('base',['exist(''' name ''')~=1']))
end

assert(exist([name])>=2 && exist([name])<=6,['File ''' name ''' not found']);

end