-- How can you produce a list of the start times for bookings by members named 'David Farrell'?

select starttime
from cd.bookings cdb
join cd.members cdm on cdb.memid = cdm.memid
where cdm.firstname = 'David' and cdm.surname = 'Farrell';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time

select starttime, name
from cd.bookings cdb
join cd.facilities cdf on cdb.facid = cdf.facid
where cdf.name in ('Tennis Court 1', 'Tennis Court 2') and cdb.starttime = '2012-09-21'
order by cdb.starttime;

-- How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.

select distinct concat(cdm.firstname, ' ', cdm.surname) as member, cdf.name 
from cd.members cdm
join cd.bookings cdb
on cdm.memid = cdb.memid
join cd.facilities cdf
on cdb.facid = cdf.facid
where cdf.name in ('Tennis Court 1','Tennis Court 2')
order by member;

-- The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.    

insert into cd.facilities (facid,name,membercost,guestcost,initialoutlay,monthlymaintenance)
values(9, 'Spa', 20, 30, 100000, 800) ;

-- add multiple facilities in one command. Use the following values: facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
-- facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.

insert into cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
values (9, 'Spa', 20, 30, 100000, 800), (10, 'Squash Court 2', 3.5, 17.5, 5000, 80);     

-- We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

update cd.facilities
set initialoutlay = 10000;

-- We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for members, and 30 for guests.

update cd.facilities
set membercost = 6, guestcost = 30;

-- We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

delete from cd.members
where memid = 37;

-- delete all members who have never made a booking
delete from cd.members
where memid not in (select memid from cd.bookings);

-- Produce a count of the number of facilities that have a cost to guests of 10 or more.
select count(*)
from cd.facilities
where guestcost = 10;

-- Produce a count of the number of recommendations each member has made. Order by member ID.
select recommendedby, count(*)
from cd.members
where recomendedby is not null
group by recommendedby
order by recommendedby;   

-- Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.
select facid, sum(slots)
from cd.bookings
group by facid
order by facid;

-- Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
select facid, sum(slots) as "Total Slots"
from cd.bookings
where starttime >= '2012-09-01' and starttime < '2012-10-01'
group by facid
order by sum(slots);     

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
select facid, extract(month from starttime), sum(slots)
from cd.bookings
where extract(year from starttime) = 2012
group by facid, month
order by facid, month;

-- Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.
select facid, sum(slots)
from cd.bookings
group by facid
having slots > 1000
order by facid;

-- Output the facility id that has the highest number of slots booked
select facid, sum(slots) as "Total Slots"
from cd.bookings
group by facid
order by sum(slots) desc
LIMIT 1;        

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities.
select count(slots), extract(month from starttime)
from cd.bokings
where starttime >= '2012-01-01' and starttime <= '2013-01-01'
group by facid
order by facid