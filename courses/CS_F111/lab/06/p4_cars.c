#include <stdio.h>

struct car
{
    char name[20];
    int model_year;
    float mileage;
    int cap;
};

int main()
{
    int i;
    struct car c[3];
    printf("Enter the details of three car :\n");

    for (i = 0; i < 3; i++)
    {
        printf("Car %d\n", i + 1);
        getchar();
        printf("Car Name   : ");
        scanf("%[^\n]s", c[i].name);

        printf("Model Year : ");
        scanf("%d", &c[i].model_year);

        printf("Capacity   : ");
        scanf("%d", &c[i].cap);

        printf("Mileage    : ");
        scanf("%f", &c[i].mileage);
        printf("\n");
    }

    int elder, pos;
    for (i = 0, pos = i, elder = c[i].model_year; i < 3; i++)
        if (elder > c[i].model_year)
        {
            pos = i;
            elder = c[i].model_year;
        }

    printf("The following are details of the oldest car :\n");

    printf("Car Name   : %s \n", c[pos].name);
    printf("Model Year : %d \n", c[pos].model_year);
    printf("Capacity   : %d \n", c[pos].cap);
    printf("Mileage    : %f \n", c[pos].mileage);

    return 0;
}
