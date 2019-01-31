%{
    #include<stdio.h>
    #include<time.h>
    #include<string.h>
%}
date ([0-9]{2}[-/.]){2}[0-9]{4}
%%
{date} {    
    // Parse into integer variables
    int d, m, y;
    char ds[2], ms[2], ys[4];
    strncpy(ms, yytext, 2);
    sscanf(ms, "%d", &m);
    
    strncpy(ds, yytext + 3, 2);
    sscanf(ds, "%d", &d);

    strncpy(ys, yytext + 6, 4);
    sscanf(ys, "%d", &y);

    if (checkDate(d, m, y)) {
        char replace[10];
        strcpy(replace, yytext);
        char c = replace[0];
        replace[0] = replace[3];
        replace[3] = c;
        c = replace[1];
        replace[1] = replace[4];
        replace[4] = c;
        printf("%s\n", replace);
    } else {
        printf("invalid input\n");
    }
}
%%
main(int argc, char **argv){
    yylex();
}

// helper function that validates date
int checkDate(int d, int m, int y) {
    time_t date;
    struct tm test_time1, test_time2, *gmt;
    test_time1.tm_sec = 0;
    test_time1.tm_min = 0;
    test_time1.tm_hour = 0;
    test_time1.tm_mday = d;
    test_time1.tm_mon = m - 1;
    test_time1.tm_year = (y < 100) ? y + 100 : y - 1900;

    memcpy(&test_time2, &test_time1, sizeof(struct tm));
    date = mktime(&test_time2);
    gmt = localtime(&date);
    return  !( test_time1.tm_mday != gmt->tm_mday || test_time1.tm_mon != gmt->tm_mon || test_time1.tm_year != gmt->tm_year );
}

int yywrap(){
    return 1;
}