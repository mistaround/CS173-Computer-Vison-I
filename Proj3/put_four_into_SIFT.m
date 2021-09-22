function SIFT = put_four_into_SIFT(Four,SIFT,ind,row)
    for f = 1:4
        [~,sift_next] = vl_sift(Four{1,f});
        SIFT{row,ind} = sift_next;
        row = row + 1;
    end
end

