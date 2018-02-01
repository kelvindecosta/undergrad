create table CUSTOMER (
    CustID int,
    CustSname varchar(50),
    CustTitle varchar(5),
    CustPhone int,
    primary key (CustID)
);

drop table CUSTOMER;

alter table CUSTOMER
modify column CustPhone varchar (10);

insert into CUSTOMER
values(43, "Mogul", "Mr", "07422971");

insert into CUSTOMER
values(51, "Dannisake", "Mrs", "06454853");

insert into CUSTOMER
values(127, "Borge", "Dr", "16468191");

create table HIRERATE (
    ToolCat varchar(20),
    HireRate int,
    Deposit int,
    primary key(ToolCat)
);

drop table HIRERATE;

insert into HIRERATE
values("Joinery", 31, 50);

insert into HIRERATE
values("Building", 31, 60);

insert into HIRERATE
values("Decorating", 20, 40);

insert into HIRERATE
values("Misc", 20, 40);

create table TOOL (
    ToolID int,
    ToolName varchar(20),
    ToolCat varchar(20),
    primary key (ToolID),
    foreign key (ToolCat) references HIRERATE(ToolCat)
);

drop table TOOL;

insert into TOOL
values (3215, "Circular Saw", "Joinery");

insert into TOOL
values (3299, "Drill", "Building");

insert into TOOL
values (3371, "Hammer", "Misc");

insert into TOOL
values (3377, "Sander", "Decorating");

insert into TOOL
values (3379, "Wallpaper Stripper", "Decorating");

insert into TOOL
values (3225, "Buzz Saw", "Joinery");

insert into TOOL
values (3229, "Axe", "Joinery");

create table TOOLAccessory (
    ToolID int,
    AccessoryName varchar(20),
    foreign key (ToolID) references TOOL(ToolID),
    constraint ToolAccessory_PK primary key(ToolID, AccessoryName)
);

drop table TOOLAccessory;

insert into TOOLAccessory
values(3215, "Blades");

insert into TOOLAccessory
values(3225, "7A PowerPack");

insert into TOOLAccessory
values(3299, "Bit set");

insert into TOOLAccessory
values(3377, "Sanding Disc");

insert into TOOLAccessory
values(3377, "Polishing Disc");

insert into TOOLAccessory
values(3377, "7A PowerPack");

create table HIRE (
    ToolID int,
    CustID int,
    HireStart date,
    HireEnd date,
    Quantity int,
    foreign key (ToolID) references TOOL(ToolID),
    foreign key (CustID) references CUSTOMER(CustID),
    constraint Hire_PK primary key(ToolID, CustID)
);

drop table HIRE;

insert into HIRE
values(3225, 43, "13/02/13", "14/02/13", 1);

insert into HIRE
values(3377, 43, "13/02/13", "15/02/13", 2);

insert into HIRE
values(3377, 51, "14/02/13", "15/02/13", 1);

insert into HIRE
values(3299, 127, "26/02/13", "29/02/13", 2);

insert into HIRE
values(3299, 127, "28/02/13", "29/02/13", 3);

insert into HIRE
values(3229, 51, "28/02/13", "29/02/13", 1);

select *
from TOOLAccessory
where ToolID = 3377;

select a.ToolID,
    a.AccessoryName,
    t.ToolName,
    t.ToolCat
from TOOLAccessory a,
    TOOL t
where a.ToolID = t.ToolID
    and a.ToolID = 3377;

select *
from CUSTOMER
where CustTitle = 'Mr';