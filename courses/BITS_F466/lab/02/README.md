# XML - Restrictions

## [`Cart`](Cart/Cart.xsd)

XML Schema for Cart details :

```
Cart
    - Item
        - Name
        - Qty
        - Cost
```

## [`University`](University/University.xsd)

XML Schema for University details :

```
University
    - Name
    - Director
        - Name
        - HOD
            - Name
            - Department
                - Name
                - Faculty
                    - Name
                    - ID
                    - Subject
                        - Name
                        - Student
                            - Name
                            - ID
```
