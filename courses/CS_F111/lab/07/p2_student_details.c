#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct
{
  char idno[13];
  char name[50];
  char gender;
  char res_status;
  float cgpa;
  char emailaddress[33];
} STUDENT;

void populate_records(STUDENT arr[]);
void generate_email_address(char id[], char email[]);
void print_records(STUDENT arr[]);
float cal_acgpa(STUDENT arr[]);
void count_m_f(STUDENT arr[]);
void create_id(STUDENT arr[], char *Idno[]);
void sort_strings(char *idnos[], int n);

void main()
{
  STUDENT arr[6];
  int n = 0;
  populate_records(arr);
  print_records(arr);

  printf("Average CGPA : %0.2f\n\n", cal_acgpa(arr));
  count_m_f(arr);
  for (int i = 0; i < 6; i++)
    if (arr[i].res_status == 'D')
      n++;
  char *idno[n];
  create_id(arr, idno);
  printf("\n\nDAY SCHOLAR IDs :\n");
  sort_strings(idno, n);
}

void populate_records(STUDENT arr[])
{
  for (int i = 0; i < 6; i++)
  {
    scanf("%[^,]s", arr[i].idno); //Or arr[i].idno = strtok(line,",")
    getchar();
    scanf("%[^,]s", arr[i].name);
    getchar();

    scanf("%c", &arr[i].gender);
    getchar();
    scanf("%c", &arr[i].res_status);
    getchar();
    scanf("%f", &arr[i].cgpa);
    getchar();

    generate_email_address(arr[i].idno, arr[i].emailaddress);
  }
}

void print_records(STUDENT arr[])
{
  for (int x = 1; x < 113; x++)
    printf("-");

  printf("|%63s%47s|\n", "STUDENT DETAILS", " ");
  printf("|");
  for (int x = 1; x < 111; x++)
    printf("-");
  printf("|");

  printf("|%8s%6s|%22s%18s|%6s|%6s|%5s%1s|%19s%14s|\n", "ID", " ", "NAME", " ", "GENDER", "STATUS", "CGPA", " ", "EMAIL", " ");
  for (int x = 1; x < 113; x++)
    printf("-");

  for (int i = 0; i < 6; i++)
  {
    printf("|%-14s|%-40s|%6c|%6c|%-06.2f|%-33s|\n", arr[i].idno, arr[i].name, arr[i].gender, arr[i].res_status, arr[i].cgpa, arr[i].emailaddress);
  }

  for (int x = 1; x < 113; x++)
    printf("-");
}

void generate_email_address(char id[], char email[])
{
  int j = 0;
  email[j] = 'f';
  j++;
  for (int i = 0; i < 4; i++, j++)
    email[j] = id[i];
  for (int i = 8; i < 11; i++, j++)
    email[j] = id[i];
  email[j] = '\0';
  strcat(email, "@dubai.bits-pilani.ac.in");
}

float cal_acgpa(STUDENT arr[])
{
  float Average, Total = 0.0;
  for (int i = 0; i < 6; i++)
    Total += arr[i].cgpa;
  Average = Total / 6;
  return Average;
}

void count_m_f(STUDENT arr[])
{
  int count_m = 0, count_f = 0;
  for (int i = 0; i < 6; i++)
  {
    if (arr[i].gender == 'M')
      count_m++;
    else
      count_f++;
  }
  printf("Number of male students: %d \n", count_m);
  printf("Number of female students: %d \n", count_f);
}

void create_id(STUDENT arr[], char *Idno[])
{
  int j = 0;
  for (int i = 0; i < 6; i++)
    if (arr[i].res_status != 'H')
      Idno[j++] = arr[i].idno;
}

void sort_strings(char *idnos[], int n)
{
  for (int i = 0; i < n; i++)
  {
    for (int j = i + 1; j < n; j++)
      if (strcmp(idnos[i], idnos[j]) > 0)
      {
        char *temp;
        temp = idnos[i];
        idnos[i] = idnos[j];
        idnos[j] = temp;
      }
    printf("%s\n", idnos[i]);
  }
}
