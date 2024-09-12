{"metadata":{"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"mimetype":"text/x-r-source","name":"R","pygments_lexer":"r","version":"3.6.0","file_extension":".r","codemirror_mode":"r"}},"nbformat_minor":4,"nbformat":4,"cells":[{"cell_type":"markdown","source":"# Cyclistic Bike-share Case Study\n\n**How does a bike-share navigate speedy success?**\n\nAkshay Kumar Mehta\n\n4th September, 2024","metadata":{}},{"cell_type":"markdown","source":"# **Table of Contents**\n1. About the (fictional) Company\n2. The Business Task\n3. Data Sources Used\n4. Cleaning & Manipulation Documentation\n5. Analysis Summary\n6. Supporting Visualizations & Key Findings\n7. My Top Three Recommendations\n\n**Disclaimer**: The data used in this case study was made available by Motivate International Inc. through [this](https://divvybikes.com/data-license-agreement) license. ","metadata":{}},{"cell_type":"markdown","source":"# **About the (fictional) company**\n\nIn 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to 5,824 bicycles that are geotracked and locked into a network of 692 stations\nacross Chicago. The bikes can be unlocked from one station and returned to any other station.\n\nUntil now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the\nflexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.\n\nCyclistic’s finance analysts have concluded that annual members are much more profitable\nthan casual riders. Although the pricing flexibility helps Cyclistic attract more customers, the team believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, the team believes\nthere is a solid opportunity to convert casual riders into members. Casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.\n\nTeam Goal: Design marketing strategies aimed at converting casual riders into\nannual members. In order to do that, however, the team needs to better understand how\nannual members and casual riders differ, why casual riders would buy a membership, and how\ndigital media could affect their marketing tactics.","metadata":{}},{"cell_type":"markdown","source":"# **The Business Task**\n\nHow can we turn casual riders into annual members?\n\nIdentifying bike usage behavior for each customer segment could reveal the motivation behind riding casually over annually, which will in turn give the team data on why some riders chose the single-pass or the day-pass and how they can implement a marketing strategy to convert casual riders into annual members based on these behaviors and motivations.\n\n**Key stakeholders:**\nDirector of Marketing\nMarketing analytics team\nExecutive team\n\n**Business Task Statement:** *Identify key differences in bike usage behavior of Cyclistic customers: casual riders and annual members.*","metadata":{}},{"cell_type":"markdown","source":"# **Data Sources Used**\n\nThis public data has been made available by Motivate International Inc.\nThe data source is reliable (no gaps or bias), original (collected by a first-party), comprehensive (has info needed to solve the business task), and the source is cited.\nThis data is from 2019, so it is not current/up-to-date, but we are working with a fictional company so this is not a problem.\nI am citing the source of the data which has a license for free use.\nThe data was collected in real time and the info is not retractable, therefore, user data is secure.\nThe source shows data on bike usage and also includes membership type, which is what we need to address the business task.\nThe data contains nulls, different formats, and missing columns in a few datasets. These will be dealt with in the cleaning phase.","metadata":{}},{"cell_type":"markdown","source":"# **Cleaning & Manipulation Documentation**\n\n1. I downloaded 2019 Q1 and 202 Q2 datasets from the dataset list\n2. I uploaded the datasets into their individual Google sheets\n3. I started off by deleting any duplicate data entries using the “Remove duplicates” function under “Data cleanup”\n    1. No duplicate data entries were found in either dataset\n4. I deleted any rows that were missing critical data (ex: start time, end_lng etc.)\n    1. Critical data is data that is absolutely essential to the analysis and business task\n    2. 4 rows were deleted in the 2019_Q1 data set and 3 rows were deleted in the 2020_Q1 dataset\n    3. I decided to ignore the blanks and hide the columns “gender” and “birth year” as I determined these were not critical to the business task\n5. I separated the start_time and end_time column data into 2 columns so the day and time can be used for calculations separately; this was done using the “split text to columns” function with the space being the separator\n    1. 4 columns were created: start_date, start_time, end_date and end_time\n6. I added a ride_length column to each dataset calculating the total length of each ride\n    1. Formula used was end_time minus start_time\n7. I formatted the start_time, end_time, and ride_length columns to be in “time” format using HH:MM:SS to ensure consistency and proper formatting\n8. I added a new column named day_of_week to indicate which day each trip occurred, using the WEEKEND formula, where 1 represents Sunday and 7 represents Saturday\n9. I sorted the datasets based on the start_date column in ascending order for organization\n10. I added bold formatting to the headers in each dataset for formatting purposes\n11. I spaced each column appropriately according to the data inside the column cells for ease of visibility","metadata":{}},{"cell_type":"markdown","source":"# Analysis Summary in R\n\n* I first got everything set up in R\n    * Installed the necessary packages (tidyverse, conflicted, dplyr)\n    * Uploaded the 2 CSV files\n    * Uploaded the datasets using the “read_csv” function and assigning each dataset as q1_2019 and q1_2020","metadata":{}},{"cell_type":"code","source":"install.packages (\"tidyverse\")\ninstall.packages (\"dplyr\")\ninstall.packages (\"conflicted\")\nlibrary(\"tidyverse\")\nlibrary(\"dplyr\")\nlibrary(\"conflicted\") # Use the conflicted package to manage conflicts\n\n# Set dplyr::filter and dplyr::lag as the default choices\nconflict_prefer(\"filter\", \"dplyr\")\nconflict_prefer(\"lag\", \"dplyr\")\n\n# # Upload Divvy datasets (csv files)\nq1_2019 <- read_csv(\"Divvy_Trips_2019_Q1.csv\")\nq1_2020 <- read_csv(\"Divvy_Trips_2020_Q1.csv\")","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"\n* Then I wrangled the data and combined the 2 datasets into a single file\n    * Used “colnames” to assess compatibility\n    * Rename the columns in the q1_2019 table to match the column names in the q1_2020 table using the “rename” function\n        * I override the table q1_2019 with this table that has the new column names\n        * This is so when I reference it later on, the correct column names will be addressed\n    * Inspect the data frames and look for incongruencies\n        * I see some data in the corresponding columns are not characterized the same\n    * Convert ride_id and rideable_type to character so that they can stack correctly using the “mutate” function\n        * I again use the assignment operator to assign this mutated data to the original q1_2019 table\n    * Stack individual quarter's data frames into one big data frame using “bind_rows”\n    * Remove lat, long, birthyear, and gender fields as this data was dropped beginning in 2020 using select(-c(...\n        * We do not need the first dataframe with all the column names, so we can replace it with the new table that has only the relevant column names","metadata":{}},{"cell_type":"code","source":"# Compare column names each of the files\n\n# Names need to match perfectly before joining them into one file\ncolnames(q1_2019)\ncolnames(q1_2020)\n\n# Rename columns to make them consistent with q1_2020\n(q1_2019 <- rename(q1_2019\n,ride_id = trip_id\n,rideable_type = bikeid\n,started_at = start_time\n,ended_at = end_time\n,start_station_name = from_station_name\n,start_station_id = from_station_id\n,end_station_name = to_station_name\n,end_station_id = to_station_id\n,member_casual = usertype\n))\n\n# Inspect the dataframes and look for incongruencies\nstr(q1_2019)\nstr(q1_2020)\n\n# Convert ride_id and rideable_type to character so that they can stack correctly\nq1_2019 <- mutate(q1_2019, ride_id = as.character(ride_id)\n,rideable_type = as.character(rideable_type))\n\n# Stack individual quarter's data frames into one big data frame\nall_trips <- bind_rows(q1_2019, q1_2020)#, q3_2019)#, q4_2019, q1_2020)\n\n# Remove lat, long, birthyear, and gender fields as this data was dropped beginning in 2020\nall_trips <- all_trips %>%\nselect(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender, \"tripduration\"))","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* Next I cleaned up and add data for analysis\n    * Consolidated the \"member_casual\" column from four labels to two using the mutate and recode function\n    * Provide additional opportunities to aggregate the data by adding columns of data such as day, month, and year using the “format(as.Date…” function\n    * Add a calculated field for length of ride since the 2020Q1 data does not have the \"tripduration\" column, by adding \"ride_length\" to the entire dataframe using the “difftime” function\n        * Converted \"ride_length\" from Factor to numeric so I could run calculations on the data using the “is.factor”, “as.numeric”, is.numeric” functions\n    * Create a new version of the data frame without rides with negative tripduration and several hundred rides where Divvy took bikes out of circulation for Quality Control reasons using the delete or drop rows with conditions function","metadata":{}},{"cell_type":"code","source":"# Inspect the new table\ncolnames(all_trips) #List of column names\nnrow(all_trips) #How many rows are in data frame?\ndim(all_trips) #Dimensions of the data frame?\nhead(all_trips) #See the first 6 rows of data frame. Also tail(all_trips)\nstr(all_trips) #See list of columns and data types (numeric, character, etc)\nsummary(all_trips) #Statistical summary of data. Mainly for numerics\n\n# There are a few problems that need to be fixed:\n\n# (1) In the \"member_casual\" column, there are two names for members (\"member\" and\n\"Subscriber\") and two names for casual riders (\"Customer\" and \"casual\"). Need to\nconsolidate that from four to two labels.\n# (2) The data can only be aggregated at the ride-level, which is too granular. Add some additional columns of data -- such as day, month, year -- that provide additional\nopportunities to aggregate the data.\n# (3) Add a calculated field for length of ride since the 2020Q1 data did not have\nthe \"tripduration\" column. Add \"ride_length\" to the entire dataframe for consistency.\n# (4) There are some rides where tripduration shows up as negative, including several hundred\nrides where Divvy took bikes out of circulation for Quality Control reasons. Delete these rides.\n# In the \"member_casual\" column, replace \"Subscriber\" with \"member\" and \"Customer\" with\n\"casual\"\n# Before 2020, Divvy used different labels for these two types of riders ... make the dataframe consistent with their current nomenclature\n\ntable(all_trips$member_casual) # to see how many observations fall under each usertype\n\n# Reassign to the desired values (uaing current 2020 labels)\nall_trips <- all_trips %>%\nmutate(member_casual = recode(member_casual\n,\"Subscriber\" = \"member\"\n,\"Customer\" = \"casual\"))\n\n# Check to make sure the proper number of observations were reassigned\ntable(all_trips$member_casual)\n\n# Add columns that list the date, month, day, and year of each ride\n# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level\nall_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd\nall_trips$month <- format(as.Date(all_trips$date), \"%m\")\nall_trips$day <- format(as.Date(all_trips$date), \"%d\")\nall_trips$year <- format(as.Date(all_trips$date), \"%Y\")\nall_trips$day_of_week <- format(as.Date(all_trips$date), \"%A\")\n\n# Add a \"ride_length\" calculation to all_trips (in seconds)\nall_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)\n\n# Inspect the structure of the columns\nstr(all_trips)\n\n# Convert \"ride_length\" from Factor to numeric to run calculations on the data\nis.factor(all_trips$ride_length)\nall_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))\nis.numeric(all_trips$ride_length)\n\n# Remove \"bad\" data\n# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative\n\n# Create a new version of the dataframe (v2) since data is being removed\nall_trips_v2 <- all_trips[!(all_trips$start_station_name == \"HQ QR\" | all_trips$ride_length<0),]","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* After all this, I conducted descriptive analysis\n    * Generated a summary of the dataset (mean, median, max, etc.)\n    * Compare members and casual riders by aggregating the data\n    * Compare average ride time by each day for members vs casual users\n        * The day order was off so I fixed it using the “ordered” and “levels” function\n    * Compared average daily number of rides and average duration for each type of rider per day of the week using the “mutate”, “group_by”, “summarise”, “mean”, and “arrange functions”","metadata":{}},{"cell_type":"code","source":"# Descriptive analysis on ride_length (all figures in seconds)\nmean(all_trips_v2$ride_length) #straight average (total ride length / rides)\nmedian(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths\nmax(all_trips_v2$ride_length) #longest ride\nmin(all_trips_v2$ride_length) #shortest ride\n\n# Can condense the four lines above to one line using summary() on the specific attribute\nsummary(all_trips_v2$ride_length)\n\n# Compare members and casual users\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)\n\n# See the average ride time by each day for members vs casual users\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,\nFUN = mean)\n\n# Days of the week are out of order. Let's fix that.\nall_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c(\"Sunday\", \"Monday\",\n\"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\"))\n\n# Run the average ride time by each day for members vs casual users\naggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week,\nFUN = mean)\n\n# analyze ridership data by type and weekday\nall_trips_v2 %>%\nmutate(weekday = wday(started_at, label = TRUE)) %>% #creates weekday field using\nwday()\ngroup_by(member_casual, weekday) %>% #groups by usertype and weekday\nsummarise(number_of_rides = n() #calculates\nthe number of rides and average duration\n,average_duration = mean(ride_length)) %>% # calculates the average\nduration\narrange(member_casual, weekday) # sorts","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"# Supporting Visualizations and Key Findings\n\n**Key findings:** *Members have frequent short trips, whereas casual riders have less frequent longer trips.*\n* Casual riders use the product and service longer than members.\n* Averages in ride length across the board (mean, min, max, median) are all led by casual riders.\n* Average ride length per day is led by casual riders.\n* The number of rides per day are led by members.\n\n**Supporting visualizations:**\n\n![](https://942c5afe5887463f8a339d4627cd559f.app.posit.cloud/file_show?path=%2Fcloud%2Fproject%2FDaily+ride+average.png)","metadata":{}},{"cell_type":"code","source":"#Generates initial visualization\nnum_of_rides <- all_trips_v2 %>%\n+     mutate(weekday = wday(started_at, label = TRUE)) %>%\n+     group_by(member_casual, weekday) %>%\n+     \n+     summarise(number_of_rides = n()\n+               ,average_duration = mean(ride_length)) %>%\n+     arrange(member_casual, weekday) %>%\n+     ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +\n+     geom_col(position = \"dodge\")\n\n#Customizes visualization\nnum_of_rides + labs(title = \"Daily Ride Average\", subtitle = \"Average number of rides per day per user\", x = \"Day of the Week\", y = \"Number of Rides\") + guides(fill=guide_legend(title=NULL))","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"![](https://942c5afe5887463f8a339d4627cd559f.app.posit.cloud/file_show?path=%2Fcloud%2Fproject%2FAverage+ride+length.png)","metadata":{}},{"cell_type":"code","source":"#Generates initial visualization\naverage_length <- all_trips_v2 %>%\n+     mutate(weekday = wday(started_at, label = TRUE)) %>%\n+     group_by(member_casual, weekday) %>%\n+     summarise(number_of_rides = n()\n+               ,average_duration = mean(ride_length)) %>%\n+     arrange(member_casual, weekday) %>%\n+     ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +\n+     geom_col(position = \"dodge\")\n\n#Customizes visualization\naverage_length + labs(title = \"Average Daily Ride Length\", subtitle = \"Average length of rides per day per user\", x = \"Day of the Week\", y = \"Average Ride Length (seconds)\") + guides(fill=guide_legend(title=NULL))","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"# My Top Three Recommendations\n\nBased on my analysis, I conclude that casual riders take longer trips but less frequently whereas members take shorter trips more frequently. There might be a misconception amongst casual rides believing Cyclistic membership has to do more with frequency of rides versus duration.\n\nI recommend:\n1. The marketing team should clearly identify our casual riding avatar traits and behaviors, such as longer ride duration and less frequent trips, to be used for campaign targeting.\n2. Conduct a focus group or send out surveys to casual riders to understand the motivation behind their less frequent, longer trips.\n3. Cyclistic could invest resources into developing a new membership program tailored to casual rider needs and the marketing team can develop campaigns that better target casual riders with said membership.","metadata":{}}]}