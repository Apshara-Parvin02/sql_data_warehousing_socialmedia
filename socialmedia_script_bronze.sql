-- DATA WAREHOUSING PROJECT.

-- ===============================================================================================================================
-- BRONZE LAYER.(Raw data import and validation)
-- ===============================================================================================================================

create database social_media_dw;
use social_media_dw;
-- data imported from csv.
select * from socialmedia limit 10;
rename table socialmedia to bronze_socialmedia;
desc bronze_socialmedia;
select count(*) from bronze_socialmedia;
select app_name, count(*) from bronze_socialmedia group by app_name;

