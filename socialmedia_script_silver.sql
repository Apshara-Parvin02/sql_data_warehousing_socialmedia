-- ===============================================================================================================================
-- SILVER LAYER.(Data cleaning and validation)
-- ===============================================================================================================================

create table silver_socialmedia as
select * from bronze_socialmedia;
select * from silver_socialmedia limit 10;
set sql_safe_updates = 0;
delete from silver_socialmedia                --  deleting duplicate user_id if exist.
where user_id not in(
      select * from(
         select min(user_id)
         from silver_socialmedia
         group by user_id) as temp
         );
         
select                                          -- checking for any null count. (no null value found)
	count(*) as total_rows,
	count(age) as age_filled,
	count(gender) as gender_filled,
	count(country) as country_filled,
	count(exercise_hours_per_week) as missing_exercise,
	count(sleep_hours_per_night) as missing_sleep
from silver_socialmedia;

select * from silver_socialmedia                -- checking invalid age.(no invalid age found)
where age < 10 or age > 100;

select * from silver_socialmedia                -- checking invalid bmi.(no invalid bmi found)
where body_mass_index < 10 or body_mass_index > 60;

select * from silver_socialmedia                 -- checking invalid sleep hours.( no invalid sleep hours found)
where sleep_hours_per_night < 0 or sleep_hours_per_night > 24;

update silver_socialmedia                         -- standardizing category values.
set gender = 'Female'
where gender in ('female','F');

update silver_socialmedia                         -- standardizing category values.
set gender = 'Male'
where gender in ('male','M');

update silver_socialmedia                         -- standardizing category values.
set urban_rural = 'Urban'
where lower(urban_rural) = 'urban';