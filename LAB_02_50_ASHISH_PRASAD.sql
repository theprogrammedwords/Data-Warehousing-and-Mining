-- Practical 2 

/*

Problem Statement: Write and Execute SQL aggregation queries for data warehouse. '

*/



/*

Name				: Ashish Prasad

Roll No				: 50

Batch 				: B2

Date of Execution 	: 16 July 2019

*/



-- Question 1

/*

Find the total sales by country_id and channel_desc for the US and GB through 

the Internet and direct sales in September 2000 and October 2000 using ROLL-UP Extension. 

The query should return the following: 

 

 1. The aggregation rows that would be produced by GROUP BY , 

 2. The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month.

 3. Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.

 4. A grand total row. 

*/


SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE,
TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
AND SALES.CUST_ID=CUSTOMERS.CUST_ID
AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE);


/*CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-09            140,793
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Internet             2000-10            151,593
Internet                                292,387
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-09            723,424
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
                                      1,790,032
*/


-- Question 2

/*Q2: Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales 
in September 2000 and October 2009 using CUBE aggregation across three dimensions- channel_desc, calendar_month_desc, 
countries.country_iso_code. 
*/ 

SELECT channels.channel_desc, calendar_month_desc,
countries.country_iso_code,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09', '2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
CUBE(channels.channel_desc, calendar_month_desc,
countries.country_iso_code);

/*
CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
                                      1,790,032
                              GB        208,257
                              US      1,581,775
                     2000-09            864,217
                     2000-09  GB        101,792
                     2000-09  US        762,425
                     2000-10            925,815
                     2000-10  GB        106,465
                     2000-10  US        819,351
Internet                                292,387
Internet                      GB         31,109
Internet                      US        261,278
Internet             2000-09            140,793
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-10            151,593
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Direct Sales                          1,497,646
Direct Sales                  GB        177,148
Direct Sales                  US      1,320,497
Direct Sales         2000-09            723,424
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297

27 rows selected.
*/


-- Question 3

/*
Q3. Find the total sales by country_iso and channel_desc for the US and France through the Internet and 
direct sales in September 2000 
*/


SELECT countries.country_iso_code, channels.channel_desc,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
    CUBE(channels.channel_desc, countries.country_iso_code);
	
/*	
CO CHANNEL_DESC         SALES$
-- -------------------- --------------
                               864,217
GB                             101,792
US                             762,425
   Internet                    140,793
GB Internet                     16,569
US Internet                    124,224
   Direct Sales                723,424
GB Direct Sales                 85,223
US Direct Sales                638,201

9 rows selected.
*/


-- Question 4

/* Q4. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 
2000 and October 2009 using PARTIAL ROLL-UP. The query should return the following: 
1.Regular aggregation rows that would be produced by GROUP BY without using ROLLUP. 
2.First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc. 
3.Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value. 
4.It does not produce a grand total row. 
*/ 

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY countries.country_iso_code, ROLLUP (calendar_month_desc, channel_desc);
	
/*CO CALENDAR CHANNEL_DESC         SALES$
-- -------- -------------------- --------------
GB 2000-09  Internet                     16,569
GB 2000-09  Direct Sales                 85,223
GB 2000-09                              101,792
GB 2000-10  Internet                     14,539
GB 2000-10  Direct Sales                 91,925
GB 2000-10                              106,465
GB                                      208,257
US 2000-09  Internet                    124,224
US 2000-09  Direct Sales                638,201
US 2000-09                              762,425
US 2000-10  Internet                    137,054
US 2000-10  Direct Sales                682,297
US 2000-10                              819,351
US                                    1,581,775

14 rows selected.
*/

-- Question 5

/*Q5. Find the total sales by country_id and channel_desc for the US and GB through 
the Internet and direct sales in September 2000 and October 2009 using PARTIAL CUBE 
aggregation on month and country code and GROUP BY on channel_desc. 
*/

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY  channel_desc, CUBE (calendar_month_desc, countries.country_iso_code);

/*CO CALENDAR CHANNEL_DESC         SALES$
-- -------- -------------------- --------------
            Internet                    292,387
GB          Internet                     31,109
US          Internet                    261,278
   2000-09  Internet                    140,793
GB 2000-09  Internet                     16,569
US 2000-09  Internet                    124,224
   2000-10  Internet                    151,593
GB 2000-10  Internet                     14,539
US 2000-10  Internet                    137,054
            Direct Sales              1,497,646
GB          Direct Sales                177,148
US          Direct Sales              1,320,497
   2000-09  Direct Sales                723,424
GB 2000-09  Direct Sales                 85,223
US 2000-09  Direct Sales                638,201
   2000-10  Direct Sales                774,222
GB 2000-10  Direct Sales                 91,925
US 2000-10  Direct Sales                682,297

18 rows selected.
*/


-- Question 6

/* Q6. Use GROUPING to create a set of mask columns for the result set of Q1. 

1. Create grouping on  channel_desc and name it as CH 
2. Create grouping calendar_month_desc and name it as MO 
3. Create grouping on  country_iso_code and name it as CO 

*/

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
	grouping(channels.channel_desc) as CH,
	grouping(calendar_month_desc) as MO,
	grouping(countries.country_iso_code) as CO
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,
countries.country_iso_code);

/*
CO CALENDAR CHANNEL_DESC         SALES$                 CH         MO         CO
-- -------- -------------------- -------------- ---------- ---------- ----------
GB 2000-09  Internet                     16,569          0          0          0
US 2000-09  Internet                    124,224          0          0          0
   2000-09  Internet                    140,793          0          0          1
GB 2000-10  Internet                     14,539          0          0          0
US 2000-10  Internet                    137,054          0          0          0
   2000-10  Internet                    151,593          0          0          1
            Internet                    292,387          0          1          1
GB 2000-09  Direct Sales                 85,223          0          0          0
US 2000-09  Direct Sales                638,201          0          0          0
   2000-09  Direct Sales                723,424          0          0          1
GB 2000-10  Direct Sales                 91,925          0          0          0
US 2000-10  Direct Sales                682,297          0          0          0
   2000-10  Direct Sales                774,222          0          0          1
            Direct Sales              1,497,646          0          1          1
                                      1,790,032          1          1          1

15 rows selected.
*/


-- Question 7

/* Q7.  Find the total sales by country_id and channel_desc for the US and GB through the Internet 
and direct sales in September 2000 and October 2009 using GROUPING SETS. 
Calculate aggregates over three groupings: 

1.     (channel_desc, calendar_month_desc, country_iso_code) 
2.     (channel_desc, country_iso_code) 
3.     (calendar_month_desc, country_iso_code)

*/

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
	grouping(channels.channel_desc) as CH,
	grouping(calendar_month_desc) as MO,
	grouping(countries.country_iso_code) as CO
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
	grouping sets((channels.channel_desc, calendar_month_desc, countries.country_iso_code),
	(channels.channel_desc, countries.country_iso_code),
	(calendar_month_desc, countries.country_iso_code));
	
/*
CO CALENDAR CHANNEL_DESC         SALES$                 CH         MO         CO
-- -------- -------------------- -------------- ---------- ---------- ----------
GB 2000-09  Internet                     16,569          0          0          0
GB 2000-09  Direct Sales                 85,223          0          0          0
US 2000-09  Internet                    124,224          0          0          0
US 2000-09  Direct Sales                638,201          0          0          0
GB 2000-10  Internet                     14,539          0          0          0
GB 2000-10  Direct Sales                 91,925          0          0          0
US 2000-10  Internet                    137,054          0          0          0
US 2000-10  Direct Sales                682,297          0          0          0
GB 2000-09                              101,792          1          0          0
US 2000-09                              762,425          1          0          0
GB 2000-10                              106,465          1          0          0
US 2000-10                              819,351          1          0          0
GB          Direct Sales                177,148          0          1          0
GB          Internet                     31,109          0          1          0
US          Direct Sales              1,320,497          0          1          0
US          Internet                    261,278          0          1          0

16 rows selected.
*/

-- Question 8

/*Q: 8 Perform aggregation on amount sold. It should get aggregated by month first, 
then by all the months in each quarter, and then across all months and quarters in the year. 
*/

SELECT calendar_month_desc, calendar_quarter_desc,calendar_year,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_year IN ('1999') 
	AND countries.country_iso_code IN ('GB', 'US') 
	GROUP BY 
	ROLLUP(calendar_year,calendar_quarter_desc, calendar_month_desc);




CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
1999-01  1999-01          1999        974,628
1999-02  1999-01          1999      1,089,256
1999-03  1999-01          1999        754,027
         1999-01          1999      2,817,911
1999-04  1999-02          1999        708,061
1999-05  1999-02          1999        818,056
1999-06  1999-02          1999        729,678
         1999-02          1999      2,255,794
1999-07  1999-03          1999        893,452
1999-08  1999-03          1999        883,461
1999-09  1999-03          1999        923,577



CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
         1999-03          1999      2,700,490
1999-10  1999-04          1999        715,831
1999-11  1999-04          1999        742,248
1999-12  1999-04          1999        841,572
         1999-04          1999      2,299,652
                          1999     10,073,847
                                   10,073,847
18 rows selected.

-- Question 9

/*
Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class) and 
second roll up on(country_region and country_iso_code)
*/
 
SELECT times.calendar_month_desc as MONTH, times.calendar_quarter_desc as QUARTER, times.calendar_year as YEAR, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id = times.time_id
	AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND countries.country_iso_code IN ('GB', 'US')
	AND times.calendar_year = 1999
	GROUP BY
	ROLLUP(times.calendar_year, times.calendar_quarter_desc, times.calendar_month_desc);
	
/*
MONTH    QUARTER       YEAR SALES$
-------- ------- ---------- --------------
1999-01  1999-01       1999        974,628
1999-02  1999-01       1999      1,089,256
1999-03  1999-01       1999        754,027
         1999-01       1999      2,817,911
1999-04  1999-02       1999        708,061
1999-05  1999-02       1999        818,056
1999-06  1999-02       1999        729,678
         1999-02       1999      2,255,794
1999-07  1999-03       1999        893,452
1999-08  1999-03       1999        883,461
1999-09  1999-03       1999        923,577

MONTH    QUARTER       YEAR SALES$
-------- ------- ---------- --------------
         1999-03       1999      2,700,490
1999-10  1999-04       1999        715,831
1999-11  1999-04       1999        742,248
1999-12  1999-04       1999        841,572
         1999-04       1999      2,299,652
                       1999     10,073,847
                                10,073,847

18 rows selected.
*/

-- Question 10

/*
Q10. Consider the following Query and make conclusion from the result obtained. 
Query: (scott Schema) 
 
SELECT deptno, job, SUM(sal) 
FROM emp 
GROUP BY CUBE(deptno, job) 
*/


SELECT channels.channel_total, channels.channel_class, countries.country_iso_code, countries.country_region, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(channels.channel_total, channels.channel_class),
		ROLLUP(countries.country_region, countries.country_iso_code);
		
/*
CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
                                   GB Europe                      266,786
                                      Europe                      266,786
                                   US Americas                  2,382,647
                                      Americas                  2,382,647
                                                                2,649,433
Channel total                      GB Europe                      266,786
Channel total                         Europe                      266,786
Channel total                      US Americas                  2,382,647
Channel total                         Americas                  2,382,647
Channel total                                                   2,649,433
Channel total Direct               GB Europe                      177,148

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Direct                  Europe                      177,148
Channel total Direct               US Americas                  1,320,497
Channel total Direct                  Americas                  1,320,497
Channel total Direct                                            1,497,646
Channel total Others               GB Europe                       58,529
Channel total Others                  Europe                       58,529
Channel total Others               US Americas                    800,871
Channel total Others                  Americas                    800,871
Channel total Others                                              859,401
Channel total Indirect             GB Europe                       31,109
Channel total Indirect                Europe                       31,109

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Indirect             US Americas                    261,278
Channel total Indirect                Americas                    261,278
Channel total Indirect                                            292,387

25 rows selected.
*/

-- Question 11

/* Q11. Find the total sales by country name and channel_desc for the country name 
starting from U through the Internet and direct sales in September 2000 and October. 
*/

SELECT countries.country_name, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_name LIKE 'U%'
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,
countries.country_name);

/*
COUNTRY_NAME                             CALENDAR CHANNEL_DESC         SALES$
---------------------------------------- -------- -------------------- --------------
United Kingdom                           2000-09  Internet                     16,569
United States of America                 2000-09  Internet                    124,224
                                         2000-09  Internet                    140,793
United Kingdom                           2000-10  Internet                     14,539
United States of America                 2000-10  Internet                    137,054
                                         2000-10  Internet                    151,593
                                                  Internet                    292,387
United Kingdom                           2000-09  Direct Sales                 85,223
United States of America                 2000-09  Direct Sales                638,201
                                         2000-09  Direct Sales                723,424
United Kingdom                           2000-10  Direct Sales                 91,925

COUNTRY_NAME                             CALENDAR CHANNEL_DESC         SALES$
---------------------------------------- -------- -------------------- --------------
United States of America                 2000-10  Direct Sales                682,297
                                         2000-10  Direct Sales                774,222
                                                  Direct Sales              1,497,646
                                                                            1,790,032

15 rows selected.
*/

-- Question 12

/* Q12 . Analyze the output 
 
SELECT 
	ch.channel_desc, 
	t.calendar_month_desc, 
	co.country_iso_code, 
	SUM(s.amount_sold) sum_amount_sold, 
	GROUPING_ID( ch.channel_desc, 
	t.calendar_month_desc, co.country_iso_code) 
			grouping_id FROM sales s, customers cu, times t, channels ch, countries co 
			WHERE   s.time_id=t.time_id 
					AND s.cust_id=cu.cust_id 
					AND cu.country_id = co.country_id 
					AND s.channel_id = ch.channel_id 
					AND ch.channel_desc IN ('Direct Sales', 'Internet') 
					AND t.calendar_month_desc IN ('2001-09', '2001-10') 
					AND co.country_iso_code IN ('GB', 'US') 
							
							GROUP BY ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code); 
							
*/


/*
CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-09           336428.69           1
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Internet             2001-10           425337.31           1
Internet                                  761766           3
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-09           714062.98           1
Direct Sales         2001-10  GB        75296.44           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-10  US        566719.8           0
Direct Sales         2001-10           642016.24           1
Direct Sales                          1356079.22           3

                                      2117845.22           7



15 rows selected.

*/

SELECT 
	ch.channel_desc, 
	t.calendar_month_desc, 
	co.country_iso_code, 
	SUM(s.amount_sold) sum_amount_sold, 
		GROUPING_ID( ch.channel_desc, t.calendar_month_desc, co.country_iso_code) grouping_id
		FROM sales s, customers cu, times t, channels ch, countries co
			WHERE s.time_id=t.time_id AND 
				  s.cust_id=cu.cust_id AND 
				  cu.country_id = co.country_id AND 
				  s.channel_id = ch.channel_id AND 
				  ch.channel_desc IN ('Direct Sales', 'Internet') AND 
				  t.calendar_month_desc IN ('2001-09', '2001-10') AND 
				  co.country_iso_code IN ('GB', 'US')
 GROUP BY ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code),
 ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code)
 ORDER BY grouping_id;

/*

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  GB        36806.73           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  US       299621.96           0
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet                                  761766           3



CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales                          1356079.22           3
Internet                                  761766           3
Direct Sales                          1356079.22           3
Internet                                  761766           3
Direct Sales                          1356079.22           3

                                      2117845.22           7



83 rows selected.
*/