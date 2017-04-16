#include <stdio.h>
#include <stdlib.h>

struct node;
typedef struct node NODE;
typedef NODE *LINK;

struct node
{
  int data;
  LINK next;
};

// Displays one Node
void print_node(LINK ptr)
{
  printf("\nData : %d", ptr->data);
}

//List Declaration
typedef struct
{
  int size;
  LINK head;
} LIST;

//Create a new list
LIST create_list()
{
  LIST t;
  t.head = NULL;
  t.size = 0;
  return t;
}

//Print list
void print_list(LIST list)
{
  if (list.head == NULL)
  {
    printf("\nThe list has no elements.\n");
    return;
  }

  LINK ptr;

  ptr = list.head;

  while (ptr != NULL)
  {
    print_node(ptr);
    ptr = ptr->next;
  }
}

//Insert a node into the list
LIST insert_in_list(LIST list)
{
  LINK nl = (LINK)malloc(sizeof(NODE));

  printf("\nEnter the data of the new link : ");
  scanf("%d", &(nl->data));
  nl->next = list.head;

  list.head = nl;
  list.size++;

  return list;
}

//Delete a node from the list
LIST delete_from_list(LIST list)
{
  if (list.head == NULL)
  {
    printf("\nThe list has no elements.\n");
    return list;
  }

  printf("\n\nData to be deleted : ");
  int data;
  scanf("%d", &data);

  LINK nl;
  nl = list.head;
  if (nl->data == data)
  {
    printf("\nData deleted");
    list.head = nl->next;
    free(nl);
    return list;
  }

  while (nl->next != NULL)
  {
    if ((nl->next)->data == data)
    {
      printf("\nData deleted");
      LINK t;
      t = nl->next;
      nl->next = t->next;
      free(t);
      return list;
    }
    nl = nl->next;
  }

  return list;
}

int main()
{
  LIST sl;
  sl = create_list();
  char cont;

  do
  {
    //Menu
    printf("Choose from the following options : ");
    printf("\n[1] Print List");
    printf("\n[2] Insert new node into List");
    printf("\n[3] Delete a node from List");
    printf("\nCurrent Option : ");

    int opt;
    scanf("%d", &opt);
    printf("\n");

    switch (opt)
    {
    case 1:
      print_list(sl);
      break;
    case 2:
      printf("\nCurrent List : \n");
      print_list(sl);
      sl = insert_in_list(sl);
      printf("\nNew List :\n");
      print_list(sl);
      break;
    case 3:
      printf("\nCurrent List :\n");
      print_list(sl);
      sl = delete_from_list(sl);
      printf("\nNew List :\n");
      print_list(sl);
      break;
    default:
      printf("Invalid option!");
      break;
    }
    printf("\nContinue list operations?(y or n) : ");
    getchar();
    scanf("%c", &cont);
    system("clear");
  } while (cont == 'y' || cont == 'Y');
  printf("\nList Operations Terminated\n");
}
