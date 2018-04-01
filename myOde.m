function dxdt = myOde(t,x,X,T,V,road,grid)

    %dxdt = 1 - interp2(T,X,V,t,x);
    
    tmp1 = find( road.x{1} > x );
    m = tmp1(1)-1;
    
    tmp2 = find( grid.t > t );
    n = tmp2(1)-1;
    
    dxdt = 1 - road.rho{1}(m,n);

end