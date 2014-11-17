function stript = stripfname(fname)
    stript = strrep(fname,'.','');
    stript = strrep(stript,'-','');
end