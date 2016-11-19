function[H,flag] = f_test(x,A, B)
    da = x -A;
    db = x -B;

    sa = var(da);
    sb = var(db);

    if(sa>sb)
        f = sa/sb;
        flag = 'A';
    else
        f = sb/sa;
        flag = 'B';
    end;

%    sa-sb;

    df = length(A) -1
    alpha= 0.05;
    fcrit = finv(alpha,df,df);
    f;
    if(f>fcrit)
        H = 1; % null rejected
    else
        H=0; %null accepted
    end;
end