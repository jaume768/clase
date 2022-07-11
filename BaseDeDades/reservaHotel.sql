create database hotel;

use hotel;

create Table hotel(
    idHotel int(255) PRIMARY KEY,
    Nom VARCHAR(1000)
);

create table reserva(
    idReserva INT(255) PRIMARY KEY,
    email VARCHAR(1000),
    fechaEntrada DATE,
    fechaSortida DATE
);

create table reserva_hotel(
    idHotel int(255),
    idReserva INT(255),
    FOREIGN KEY (idHotel) REFERENCES hotel(idHotel),
    FOREIGN KEY (idReserva) REFERENCES reserva(idReserva)
);


insert into reserva(idReserva,email,fechaEntrada,fechaSortida)
values (1,"pepito@gmail.com","2000-11-6","2000-11-9"),(2,"pepito2@gmail.com","2000-11-4","2000-11-6"),(3,"pepito3@gmail.com","2000-11-9","2000-11-11"),(4,"pepito4@gmail.com","2000-11-1","2000-11-3"),(5,"pepito5@gmail.com","2000-11-1","2000-11-20");

insert into hotel(idHotel,Nom)
VALUES (1,"Valldemossa");

insert into reserva_hotel(idHotel,idReserva)
VALUES (1,1),(1,2),(1,3),(1,4),(1,5);


SELECT count(*)
from reserva
where not (fechaSortida <= "2000-11-5" || fechaEntrada >= "2000-11-10");