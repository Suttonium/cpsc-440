drop schema if exists private cascade;

create schema private;

drop table if exists SeatRow cascade;
drop table if exists SeatNum cascade;
drop table if exists Seat cascade;
drop table if exists Customer cascade;
drop table if exists Customer cascade;
drop table if exists Ticket cascade;

create table SeatRow (
	row char(2) primary key
    constraint check_seat_row check (row = 'A' or row = 'B' or row = 'C' or row = 'D'
                                  or row = 'E' or row = 'F' or row = 'G' or row = 'H'
                                  or row = 'J' or row = 'K' or row = 'L' or row = 'M'
                                  or row = 'N' or row = 'O' or row = 'P' or row = 'Q'
                                  or row = 'R' or row = 'AA' or row = 'BB' or row = 'CC'
                                  or row = 'DD' or row = 'EE' or row = 'FF' or row = 'GG'
                                  or row = 'HH')
);

create table SeatNum (
	num int primary key
    constraint check_seat_number check (num between 1 and 15 OR num between 101 and 126)
);

create table Seat(
	seat_row char(2) not null,
	seat_number int not null,
	Section text,
	Side text,
	PricingTier text,
	Wheelchair boolean default false, --ALL OTHERS SHOULD BE FALSE--
	constraint seat_row_and_number primary key (seat_row, seat_number),
    constraint seat_row_fk foreign key (seat_row) references SeatRow(row),
    constraint seat_number_fk foreign key (seat_number) references SeatNum(num)
);

create table public.Customer(
    CustomerID int primary key,
    FirstName text,
    LastName text
);

create table private.Customer(
    CustomerID int primary key,
    CreditCard bigint,
    constraint customer_id_fk foreign key (CustomerID) references public.Customer(CustomerID)
);
    
create table Ticket(
    TicketNumber serial primary key,
    CustomerID int not null,
    SeatRow char(2) not null,
    SeatNumber int not null,
    ShowTime timestamp,
    constraint customer_id_fk foreign key (CustomerID) references public.Customer(CustomerID),
	constraint ticket_unique_check unique(SeatRow,SeatNumber,ShowTime));

insert into seatrow values('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H'),('J'),('K'),('L'),('M'),('N'),('O'),('P'),
						  ('Q'),('R'),('AA'),('BB'),('CC'),('DD'),('EE'),('FF'),('GG'), ('HH');
                          -- ALL POTENTIAL SEAT LETTERS --
insert into seatnum values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),
					      (101),(102),(103),(104),(105),(106),(107),(108),(109),(110),(111),(112),(113),(114),(115),
                          (116),(117),(118),(119),(120),(121),(122),(123),(124),(125),
                          (126); 
                          -- ALL POTENTIAL SEAT NUMBERS --
                            
insert into seat
select * from seatrow,seatnum;
-- MAKE ALL ROWS HAVE ALL NUMBERS FOR NOW...WILL ADJUST LATER --

-- UPDATE ALL EVEN SEATS GREATER THAN 100 WITH A SIDE OF RIGHT --
update seat 
set side = 'Right'
where (seat_number % 2 = 0 and seat_number > 100);

-- UPDATE ALL ODD SEATS GREATER THAN 100 WITH A SIDE OF LEFT --
update seat 
set side = 'Left'
where (seat_number % 2 != 0 and seat_number > 100);

-- ANYTHING IN THE MIDDLE SECTION SHOULD BE < 100 --
update seat 
set side = 'Middle'
where (seat_number < 100);


-- UPDATE SEAT SECTIONS --
update seat
set section = 'Balcony' -- ALL SEATS IN DOUBLE LETTERED ROWS ARE IN THE BALCONY --
where (seat_row = 'AA' or seat_row = 'BB' or seat_row = 'CC' or seat_row = 'DD' or seat_row = 'EE' or seat_row = 'FF' or seat_row = 'GG' or seat_row = 'HH');

update seat
set section = 'Main Floor' -- THE REST ARE IN THE MAIN FLOOR --
where (seat_row = 'A' or seat_row = 'B' or seat_row = 'C'
    or seat_row = 'D' or seat_row = 'E' or seat_row = 'F' 
    or seat_row = 'G' or seat_row = 'H' 
    or seat_row = 'J' or seat_row = 'K' or seat_row = 'L'
    or seat_row = 'M' or seat_row = 'N' or seat_row = 'O'
    or seat_row = 'P' or seat_row = 'Q' or seat_row = 'R') ;

-- UPDATE SEATS TO ACCOUNT FOR HANDICAPPED SPACES --
update seat
set wheelchair = true
where (
      (seat_row = 'P' or seat_row = 'Q' or seat_row = 'R') and (seat_number between 109 and 122)
      -- ACCOUNTS FOR THE BLOCKED OFF WHEELCHAIR SECTIONS --
      );

-- UPDATE SEAT PRICING TIERS --
update seat
set pricingtier = 'Upper Balcony'
where (seat_row = 'EE' or seat_row = 'FF' or seat_row = 'GG' or seat_row = 'HH');

update seat
set pricingtier = 'Orchestra'
where ((seat_row = 'AA' or seat_row = 'BB' or seat_row = 'CC' or seat_row = 'DD') AND seat_number <=15);

update seat
set pricingtier = 'Orchestra'
where (pricingtier is null AND seat_number between 1 and 106);

update seat
set pricingtier = 'Side'
where (pricingtier is null);


-- WILL DELETE ANY INVALID SEATS --
-- TIME TO ADJUST... --
delete from seat 
where(
     -- MIDDLE SECTION --
    (seat_row = 'A' and  seat_number between 11 and 15) or
    (seat_row = 'B' and  seat_number between 11 and 15) or
    (seat_row = 'C' and  seat_number between 11 and 15) or
    (seat_row = 'D' and seat_number between 12 and 15) or
    (seat_row = 'E' and seat_number between 12 and 15) or
    (seat_row = 'F' and seat_number between 12 and 15) or
    (seat_row = 'G' and seat_number between 13 and 15) or
    (seat_row = 'H' and seat_number between 13 and 15) or
    (seat_row = 'J' and seat_number between 13 and 15) or
    (seat_row = 'K' and seat_number between 14 and 15) or
    (seat_row = 'L' and seat_number between 14 and 15) or
    (seat_row = 'M' and seat_number between 14 and 15) or
    (seat_row = 'N' and seat_number = 15) or
    (seat_row = 'O' and seat_number = 15) or
    (seat_row = 'P' and seat_number = 15) or
    (seat_row = 'AA' and seat_number between 14 and 15) or 
    (seat_row = 'BB' and seat_number = 15) or
    (seat_row = 'CC' and seat_number = 15) or
    (seat_row = 'DD' and seat_number = 15) or
    (seat_row = 'EE' and seat_number between 11 and 15) or
    (seat_row = 'FF' and seat_number between 11 and 15) or
    (seat_row = 'GG' and seat_number between 12 and 15) or
    (seat_row = 'HH' and seat_number between 12 and 15) or
    
    -- SIDE SECTIONS --
    (seat_row = 'A' and seat_number > 114) or
    (seat_row = 'B' and seat_number > 116) or
    (seat_row = 'C' and seat_number > 116) or
    (seat_row = 'D' and seat_number > 116) or
    (seat_row = 'E' and seat_number > 116) or
    (seat_row = 'F' and seat_number > 118) or
    (seat_row = 'G' and seat_number > 118) or
    (seat_row = 'H' and seat_number > 118) or
    (seat_row = 'J' and seat_number > 118) or
    (seat_row = 'K' and seat_number > 120) or
    (seat_row = 'L' and seat_number > 120) or
    (seat_row = 'M' and seat_number > 120) or
    (seat_row = 'N' and seat_number > 120) or
    (seat_row = 'O' and seat_number > 122) or
    (seat_row = 'P' and seat_number > 122) or
    (seat_row = 'Q' and seat_number > 122) or
    (seat_row = 'R' and seat_number > 122) or
    (seat_row = 'AA' and seat_number > 124) or 
    (seat_row = 'BB' and seat_number > 124) or
    (seat_row = 'CC' and seat_number > 124) or
    (seat_row = 'DD' and seat_number > 126) or
    (seat_row = 'EE' and seat_number > 122) or
    (seat_row = 'FF' and seat_number > 122) or
    (seat_row = 'GG' and seat_number > 120) or
    (seat_row = 'HH' and seat_number > 118) 
);

select * from seat
order by seat_number,seat_row;

insert into Customer
values (1234,'Mike','Johnson');

insert into private.Customer
values (1234,'1234567887654321');

insert into Ticket
values (1,1234,'A',6,'2017-12-15');

select count(*) from seat; -- sanity check --

