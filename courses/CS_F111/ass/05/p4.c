#include <stdio.h>

typedef struct courses
{
    char name[40];
    char id[10];
    int units;
} course;

void input_courses(course c[5])
{
    int i;
    printf("Enter the details of 5 courses : \n");
    for (i = 0; i < 5; i++)
    {
        printf("Course %d : \n", i + 1);

        getchar();
        printf("Course Name  : ");
        scanf("%[^\n]s", &c[i].name);

        getchar();
        printf("Course ID    : ");
        scanf("%[^\n]s", &c[i].id);

        getchar();
        printf("Course Units : ");
        scanf("%d", &c[i].units);
        printf("\n\n");
    }
}

void output_courses(course c[5])
{
    printf("                           COURSES                          \n");
    printf("____________________________________________________________");
    printf("|%22s%18s|%6s%4s| UNITS |\n", "NAME", " ", "ID", " ");
    printf("____________________________________________________________");
    int i;
    for (i = 0; i < 5; i++)
        printf("|%-40s|%-10s|%7d|\n", c[i].name, c[i].id, c[i].units);
    printf("____________________________________________________________");
}

int main()
{
    course c[5];
    input_courses(c);
    output_courses(c);

    return 0;
}
