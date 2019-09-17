# XML - Assertions

## [`Contact`](Contact.xsd)

XML Schema for Contact details :

```
ContactType (id)
    - Name
    - Age
    - Country

USContactType (id) < ContactType
    - Country == "USA"

Contact
    Alternatives
        - ContactType
        - USContactType
```
