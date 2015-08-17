function outstring = struct2str(struct, instring)

    outstring = instring;
    fieldsinStruct = fields(struct);
    
    for i=1:length(fieldsinStruct)
        fieldname = char(fieldsinStruct(i))
        value = struct.(fieldname);
        value = evalc(['disp(value)'])
        outstring = [outstring, fieldname, sprintf('\t: '),value, char(10)];
        %outstring = sprintf('\n%s', outstring);
        if(isstruct(struct.(fieldname)))
            outstring = struct2str(struct.(fieldname), outstring)
        end
    end
    
end