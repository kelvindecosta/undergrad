#include <stdio.h>

int main()
{
    char f_name[20], m_name[20], l_name[20];
    printf("Enter the following details : \n");
    printf("First Name  : ");
    scanf("%s", &f_name);
    printf("Middle Name : ");
    scanf("%s", &m_name);
    printf("Last Name   : ");
    scanf("%s", &l_name);

    printf("\nNice to meet you %s %s %s. \nIn all further correspondence,the agency will address you as Secret Agent %s.\n", f_name, m_name, l_name, l_name);
}
