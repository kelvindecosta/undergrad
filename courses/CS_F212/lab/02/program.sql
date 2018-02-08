create table MOVIE (
    Title varchar(30),
    MovieYear year,
    Length int,
    ThreeD boolean,
    StudioName varchar (20),
    Producer varchar (20),
    constraint Movie_PK primary key (Title, MovieYear)
);

insert into MOVIE
values(
        "Titanic",
        2006,
        360,
        True,
        "Paramount",
        "James Camersoon"
    );

insert into MOVIE
values(
        "Inception",
        2010,
        148,
        False,
        "Universal",
        "Christopher Nolan"
    );

insert into MOVIE
values("Avatar", 2009, 162, False, "Paramount", "Sam");

insert into MOVIE
values(
        "Speed",
        2002,
        250,
        True,
        "20th Century Fox",
        null
    );

insert into MOVIE
values(
        "Rio",
        2010,
        96,
        True,
        "Disney",
        "Carlos Saldana"
    );

create table MOVIESTAR (
    StarName varchar(30),
    Address varchar(50),
    Gender char,
    Birthdate date,
    primary key (StarName)
);

insert into MOVIESTAR
values(
        "Leonardo DiCaprio",
        "Los Angeles",
        "M",
        "1974-11-11"
    );

insert into MOVIESTAR
values("Sandra Bullock", "New York", "F", "1964-07-26");

insert into MOVIESTAR
values("Kate Winslet", "London", "F", "1975-10-05");

insert into MOVIESTAR
values("Keanu Reaves", "California", "M", "1964-09-02");

create table STARSIN (
    MovieTitle varchar(30),
    MovieYear year,
    Star varchar(30),
    constraint StarsIn_FK foreign key (MovieTitle, MovieYear) references MOVIE(Title, MovieYear),
    foreign key (Star) references MOVIESTAR(StarName),
    constraint StarsIn_PK primary key (MovieTitle, MovieYear, Star)
);

insert into STARSIN
values ("Titanic", 2006, "Leonardo DiCaprio");

insert into STARSIN
values ("Titanic", 2006, "Kate Winslet");

insert into STARSIN
values ("Speed", 2002, "Sandra Bullock");

insert into STARSIN
values ("Speed", 2002, "Keanu Reaves");

insert into STARSIN
values ("Inception", 2010, "Leonardo DiCaprio");

create table MOVIEEXEC (
    ExecName varchar(30),
    Address varchar(50),
    LicenceNo varchar(5),
    NetWorth varchar(10),
    primary key (LicenceNo)
);

insert into MOVIEEXEC
values ("Knight", "Los Angeles", "12789", "2000000");

insert into MOVIEEXEC
values ("Bridge", "California", "58999", "7890000");

insert into MOVIEEXEC
values ("Tim", "Miami", "156", "2390000");

/*SEARCH QUERIES */