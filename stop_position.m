%%%% Multiple scenario
pstmin=0;
pstmax=8000;

% Number of stops
nstops = 41.0;
ra=(7431.00)*rand(nstops,1);
nra = 150.0 - ra;
    if (ra < 150.00)        
        ra = ra+nra;
    else 
        ra;
    end
ra = sort(ra);

%%%% Mandatory stops on route.
dscd    =  [ 0 1;
             186 1;
             220 1;
             244 1;
             308 1;
             490 1;
             570 1;
             698 1;
             780 1;
             1010 1;
             1190 1;
             1650 1;
             1820 1;
             2300 1;
             2620 1;
             3070 1;
             3600 1;];
             
             
ascd =      [5400 1;
             5890 1;
             6060 1;
             6700 1;
             6750 1;
             6800 1;
             7260 1;
             7300 1;
             7330 1;
             7430 1;
             8000 1;];
pst = [dscd;ascd];     

for i= 1:length(ra)
    dmin = min(abs(pst(:,1)-ra(i)));
    if(dmin > 150.0)  
        pst=sort([pst;ra(i) 1],1);
    end
    
end