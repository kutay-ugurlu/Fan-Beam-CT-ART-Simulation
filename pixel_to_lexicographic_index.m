function lexic_idx =  pixel_to_lexicographic_index(row_index,col_index,Nrows,Ncols)
lexic_idx = Nrows*(col_index-1) + row_index;
end
