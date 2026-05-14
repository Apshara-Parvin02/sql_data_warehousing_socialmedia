-- ===============================================================================================================================
-- GOLD LAYER. (Business insights)
-- ===============================================================================================================================

create table dim_demographics as        -- DEMOGRAPHICS DIMENSION.
select distinct user_id,
                age,
                gender,
                country,
                urban_rural,
                income_level,
                employment_status,
                education_level,
                relationship_status,
                has_children
from silver_socialmedia;

create table dim_lifestyle as              -- LIFESTYLE DIMENSION.
select distinct user_id,
                exercise_hours_per_week,
                sleep_hours_per_night,
                diet_quality,
                smoking,
                alcohol_frequency,
                body_mass_index,
                blood_pressure_systolic,
                blood_pressure_diastolic,
                weekly_work_hours,
                books_read_per_year,
                social_events_per_month,
                travel_frequency_per_year
from silver_socialmedia;
                
create table dim_engagement as               -- ENGAGEMENT DIMENSION
select distinct user_id,
				ads_viewed_per_day,
                ads_clicked_per_day,
                posts_created_per_week,
                likes_given_per_day,
                comments_written_per_day,
                dms_sent_per_week,
                time_on_feed_per_day,
                stories_viewed_per_day,
                reels_watched_per_day,
                notification_response_rate,
                content_type_preference
from silver_socialmedia;

create table fact_user_behavior as         -- FACT TABLE
select 
     user_id,
     app_name,
     perceived_stress_score,
     self_reported_happiness,
     daily_active_minutes_instagram,
     sessions_per_day
from silver_socialmedia;
     
     select count(*) from dim_demographics;   -- verifying tables.
     select count(*) from dim_lifestyle;
     select count(*) from dim_engagement;
     select count(*) from fact_user_behavior;
     
-- GOLD BUSINESS ANALYTICS.

select d.age,                                                                 -- AGE VS ACTIVE TIME.
      round(avg(f.daily_active_minutes_instagram/60),2) as avg_active_time
from fact_user_behavior f
join dim_demographics d on f.user_id = d.user_id
group by d.age
order by avg_active_time desc;
             
 select d.gender,                                                               -- GENDER VS ACTIVE TIME.
        round(avg(f.daily_active_minutes_instagram/60),2) as avg_active_time
from fact_user_behavior f
join dim_demographics d on f.user_id = d.user_id
group by gender;

select d.urban_rural,                                                               -- URBAN VS RURAL USAGE.
	   round(avg(f.daily_active_minutes_instagram/60),2) as avg_active_time
from fact_user_behavior f
join dim_demographics d on f.user_id = d.user_id
group by d.urban_rural;

select d.country,                                                               -- MOST ACTIVE COUNTRY.
	   round(avg(f.daily_active_minutes_instagram/60),2) as avg_active_time
from fact_user_behavior f
join dim_demographics d on f.user_id = d.user_id
group by d.country
order by avg_active_time desc
limit 5;

select l.body_mass_index,                                                               -- BMI VS SCREEN TIME.
        round(avg(f.daily_active_minutes_instagram/60),2) as avg_active_time
from fact_user_behavior f
join dim_lifestyle l  on f.user_id = l.user_id
group by l.body_mass_index
order by avg_active_time desc;

select  e.content_type_preference,                                  -- CONTENT TYPE PREFERENCE VS ENGAGEMENT.
        round(avg(f.daily_active_minutes_instagram/60),2) as avg_engagement
from fact_user_behavior f
join dim_engagement e on f.user_id = e.user_id
group by e.content_type_preference
order by avg_engagement desc;
 
select e.notification_response_rate,               -- NOTIFICATION FATIGUE ANALYSIS.
       avg(f.perceived_stress_score) as avg_stress
from fact_user_behavior f
join dim_engagement e on f.user_id = e.user_id
group by e.notification_response_rate
order by e.notification_response_rate desc;

select l.sleep_hours_per_night,                      -- SLEEP VS STRESS
       avg(f.perceived_stress_score) as avg_stress
from fact_user_behavior f
join dim_lifestyle l on f.user_id = l.user_id
group by l.sleep_hours_per_night
order by avg_stress desc;

select user_id,                                                             -- WELLNESS SCORE.
        round(avg(daily_active_minutes_instagram/60),2) as avg_active_time,           
       (self_reported_happiness - perceived_stress_score) as wellness_score
from fact_user_behavior
group by user_id,  wellness_score 
order by wellness_score desc;

select d.user_id,                                                                      -- SOCIAL ENGAGEMENT SCORE.
         round(avg(daily_active_minutes_instagram/60),2) as avg_active_time,                 
       (d.likes_given_per_day + d.comments_written_per_day + d.posts_created_per_week) as engagement_score
from dim_engagement d 
join fact_user_behavior f on f.user_id = d.user_id
group by d.user_id, engagement_score
order by engagement_score desc;
