# Hotel-Data-Analysis

### Table of Contents
- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Dataset](#dataset)
- [Tools and Technologies Used](#tools-and-technologies-used)
- [Data Preparation](#data-preparation)
- [Key Analysis Performed](#key-analysis-performed)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)



### Project Overview
This project analyzes hotel booking data using Microsoft SQL Server to uncover valuable business insights related to:
- Booking cancellations
- Revenue performance
- Customer behavior
- Hotel performance
- Market segments
- Seasonal trends
- Room demand
- Guest patterns
The project simulates a real-world hospitality business intelligence analysis workflow using SQL.


### Objectives
The main goals of this project were to:
- Analyze hotel booking behavior
- Identify cancellation trends
- Estimate hotel revenue
- Compare city and resort hotel performance
- Understand customer booking patterns
- Explore seasonal booking trends
- Evaluate market segment performance
- Generate business recommendations using data


### Dataset
The dataset contains hotel booking information including:
- Booking status
- Lead time
- Hotel type
- Guest details
- Market segments
- Room types
- Deposit types
- Daily rates
- Special requests
- Parking requests
- Seasonal booking information


### Tools and Technologies Used
- Microsoft SQL Server


### Data Preparation
The dataset was imported into SQL Server using the Flat File Import Wizard.

Because several numeric columns were imported as text (VARCHAR), a cleaned SQL view was created using TRY_CAST() to safely convert columns into proper numeric data types.

Example:
```sql
TRY_CAST(is_canceled AS INT)
```

A clean analysis view called:
``` sql
hotel_bookings_analysis_clean
```

was created for all analytical queries.



### Key Analysis Performed
1. Data Exploration
   - Total bookings
   - Booking cancellations
   - Cancellation rates

2. Hotel Performance Analysis
   - City hotel vs resort hotel bookings
   - Cancellation rates by hotel type
   - Revenue by hotel type
  
3. Revenue Analysis
   - Estimated hotel revenue
   - Average daily room rates
   - Monthly revenue trends
     
4. Customer Analysis
    - Repeated guest analysis
    - Guest cancellation behavior
    - Average group size

6. Market Segment Analysis
    - Online travel agency bookings
    - Corporate bookings
    - Direct bookings
    - Segment cancellation rates
      
7. Booking Behavior Analysis
    - Lead time analysis
    - Parking demand
    - Special requests analysis

8. Seasonal Analysis
    - Monthly booking trends
    - Peak booking periods
    - Revenue seasonality

9. Deposit Type Analysis
    - Deposit type distribution
    - Cancellation behavior by deposit type
  


### Key Insights
- Certain market segments had significantly higher cancellation rates.
- City and resort hotels showed different booking patterns.
- Longer lead times were associated with higher cancellation behavior.
- Guests with special requests tended to cancel less frequently.
- Seasonal demand strongly influenced booking volume and revenue.
- Non-refundable deposit types reduced cancellation risk.



### Business Recommendations
1. Reduce Cancellations
    - Encourage non-refundable bookings
    - Monitor high-risk booking channels

2. Improve Revenue Management
   - Optimize pricing during peak seasons
   - Focus on profitable hotel segments
  
3. Improve Customer Loyalty
   - Develop loyalty programs for repeated guests
   - Personalize customer experiences

4. Strengthen Operational Planning
   - Use seasonal trends for staffing and resource planning
   - Prepare for parking and service demand fluctuations

