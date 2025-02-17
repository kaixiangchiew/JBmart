# Table of Contents

- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Dataset Structure](#dataset-structure)
- [Insights Deep-Dive](#insights-deep-dive)
    - [Yearly Sales Trends and Growth Rates](#yearly-sales-trends-and-growth-rates)
    - [Monthly Sales Trends and Growth Rates](#monthly-sales-trends-and-growth-rates)
    - [Product Performance](#product-performance)
    - [Loyalty Program Performance](#loyalty-program-performance)
- [Lessons and Recommendations](#lessons-and-recommendations)
- [Final Deliverable Tableau Story](#final-deliverable-tableau-story)
- [Appendix: Data Cleaning](#appendix-data-cleaning)

***

# Project Background
JBmart, an e-commerce company founded in 2018, sells popular electronics like Macbook, Samsung products. Thankfully, COVID-19 is behind us, but the insights from those years remain valuable. I'm working with the Head of Operations to take a retrospective look at our sales and loyalty program data during the peak Covid years. Our final deliverable is a [company-wide town hall presentation](https://public.tableau.com/app/profile/kai.xiang.chiew/viz/JBmartCompany-WideTownHallWhatcanwelearnfromCovid/Story1) that aims to provide insights and recommendations to the sales, product, and marketing teams.

![email_exchange](https://github.com/user-attachments/assets/cf8ffb2c-f385-4fe4-9fdf-412f1084fc31)

# Executive Summary
JBmart’s sales analysis of 78k records across 2019-2022 observed an initial revenue surge from $2.7M in 2019 to $7.2M in 2020 (+168% YoY), driven by pandemic-fueled demand, followed by a steady decline post-vaccine rollout, with revenue dropping 42% in 2022. Our findings highlight the temporary nature of pandemic-driven growth, the importance of adapting to shifting consumer spending habits, and the risks of relying on a concentrated product portfolio. Additionally, our loyalty program has shown strong engagement, with member revenue share growing from 5% in 2019 to 59% in early 2022, though a slight decline in late 2022 suggests the need for further enhancements. Moving forward, diversification of our product mix and strengthening our loyalty program will be key to long-term stability and growth.  

# Dataset Structure

JBmart’s database consists of four tables containing orders, order statuses, customers, and geographic information with a row count of 78,847 order records. 

Below is the Entity Relationship Diagram (ERD).

![entity relationship diagram](https://github.com/user-attachments/assets/0b1882e3-68be-4895-9dfa-a545fc626835)

* SQL Data Cleaning Queries: [View SQL Scripts](jbmart_data_cleaning.sql)
* SQL Targeted Business Question Queries: [View SQL Scripts](jbmart_targeted_business_questions.sql)
* Data Cleaning Changelog: [Download Excel Log](jbmart_data_cleaning_changelog.xlsx)

# Insights Deep-Dive

## Yearly Sales Trends and Growth Rates

![yearly_revenue_bar](https://github.com/user-attachments/assets/841100a9-4a50-47b4-8369-75468d91fdfa)

* **Revenue surged in 2020 but declined post-pandemic.** Sales jumped from $2.7M to $7.2M (+168%) in the 1st year Covid, driven by pandemic-driven demand. However, as the market stabilized, revenue declined by 9% in 2021 and dropped further by 42% in 2022, signaling a sharp correction.
* **Behind the 2020 revenue surge number was a tremendous effort**—especially from our warehouse teams, who works tirelessly to keep up with orders during pandemic times.

![yearly_order_volume_bar](https://github.com/user-attachments/assets/c55ef9c2-b68a-46d9-ac4c-137032ebcc50)

* **Order volume increased +6% in 2021 despite overall revenue decline in that year**, why? Customers placed more orders but shifted toward lower-cost essential items. 

![yearly_aov_bar](https://github.com/user-attachments/assets/7ab81816-a970-48d2-95e8-ac06f69e6d9c)

* **Consumers spent $70 more during 1st year covid.** AOV was rising from $226 to $296 as consumers spent more on high-ticket items like laptops.
* **Post-pandemic, AOV is almost back to Pre-Covid level**, dropping to $230 in 2022 as spending shifted toward smaller-ticket essential items like charging cable, signalling a return to pre-Covid buying behavior.

## Monthly Sales Trends and Growth Rates

![monthly_revenue_line](https://github.com/user-attachments/assets/471ac60a-752d-492c-8e27-7f1f027f536c)

* **Pre-Covid 2019 revenue follows a predictable seasonal pattern**, with no major disruption. Revenue at around $220K per month, providing a baseline to compare the sharp shifts in revenue trends during the pandemic years.
* **Revenue surged nearly 3x in 2020**, jumping from $220K to over $600K per month, driven by panic buying, physical store closure, and the shift to remote work. 
* **Some states reopen in June 2020 led to a temporary dip** as consumers returned to physical stores, but revenue rebounded due to rising Covid cases. 
* **FDA approved 2 vaccines in Dec 2020, this was a turning point**—both for public health and for businesses. But for us, was it good news or bad news?
* It was mostly bad news **in 2021 as revenue starts to decline** as vaccines rolled out and post-pandemic market conditions took place. 
* **Suez Canal blocked for 6 days worsened existing supply chain disruptions**, causing shipping delays, inventory shortages, and rising logistics costs, impacting our ability to meet demand.
* **Apple’s iOS 14.5 privacy update “Ask App Not to Track”** limited ad tracking, reducing digital advertising efficiency, increasing customer acquisition costs, and contributing to the revenue decline.
* Despite the revenue decline **in 2022, avg monthly revenue remained at $310K+, still outperforming $220K+ in 2019**, higher than Pre-Covid baseline. However, revenue from most recent months in 2022 closely resembles that of 2019. Can we compare them side-by-side for further analysis? 

### Compare Pre-Covid 2019 and Post-Covid 2022

![monthly_revenue_by_year_compare_2019_2022_line](https://github.com/user-attachments/assets/deec7247-90e5-4899-9841-c1508ace13f8)

* In early 2022, revenue remained above pre-COVID levels but declined steadily throughout the year, converging with 2019 levels by Q4—**raising the key question of whether we are returning to pre-pandemic norms or facing a lasting market shift.**

![monthly_revenue_by_year_growth_rate_line](https://github.com/user-attachments/assets/85567190-a767-4ace-81dd-4e0acd95ea43)

* **March 2021 marked a turning point—just three months after vaccine approval**, revenue entered a consistent decline, with every subsequent month showing negative growth, signaling a major market shift. The next question is: How consistent and how significant was this decline?

![yoy_monthly_revenue_growth_rate_bar](https://github.com/user-attachments/assets/1a09a7af-547b-403c-8275-cd91da2264d3)

* **After March 2021, revenue declined for 21 consecutive months**, started gradually at -4% in early 2021 but deepened to -59% by late 2022, a stark contrast to the +214% peak growth in September 2020. 
* The key question now: **What products fueled the 2020 boom and the post-2021 decline**, and how can we strategically position ourselves for recovery?

## Product Performance

![revenue_by_product_stacked_bar](https://github.com/user-attachments/assets/8d894b14-4357-450b-939f-95a40ce0f061)

* **Laptop sales surged from 25% to 41% of revenue in 2020 due to remote work and online learning but dropped back to 28% by 2022**, confirming that pandemic-driven demand was temporary and reinforcing the need to adapt to shifting consumer behavior.
* **iPhones and Bose Soundport Headphones contributed less than 1% of revenue** from 2019 to 2022, despite their strong brand recognition, possibly due to customers preferred to buy these products from official stores, limited demand shifts during Covid compared to work-from-home setups like laptop and we may not have been offering competitive pricing or attractive promotions. 
* **Samsung Webcam, introduced in 2020, grew from 0.6% to 2.4% of revenue by 2022**, demonstrating that launching the right products at the right time can create new revenue streams.

![units_sold_revenue_stacked_bar](https://github.com/user-attachments/assets/119f7669-0e29-403b-8fc8-7e633a954b71)

* **With 84% of total units sold and 70% of revenue coming from just three products**, our portfolio is highly concentrated, posing a risk—if demand for these items drops, our revenue could take a significant hit, highlighting the need for greater product diversification.

## Loyalty Program Performance

![revenue_percentage_by_loyalty_status_stacked_bar](https://github.com/user-attachments/assets/d59a806b-0bc7-4cd4-b922-0102f5f37b1f)

* **Since its launch in 2019, our loyalty program has shown strong growth**, with member revenue share increasing from 5% to 59% by Q1 2022, indicating high engagement and retention.
* However, **the decline in Q2, Q3 and Q4 2022 raises some concerns**—are we seeing membership fatigue, or is this a seasonal fluctuation? Understanding why member revenue percentage dipped will be crucial in determining our next steps.

![aov_over_time_by_loyalty_status_line](https://github.com/user-attachments/assets/b90c7aba-1827-4ac0-a48a-a0f2940a0157)

* **Member AOV steadily increased from $185 to $247.** This trend aligns with the idea that engaged, loyal customers see more value in our products and services, leading to higher ticket sizes over time.
* Non-member though historically has spent more than member, **its spending has spiked during the pandemic but has since declined.**
* After Q3 2021, we see a clear shift—**members are now outspending non-members by about $30 per order** ($247 vs. $218).
* One key takeaway here is that while non-member AOV is declining, **members are proving to be a more resilient revenue source.**

# Lessons and Recommendations

1. **Spending patterns shift.** Post-pandemic, consumers moved from high-ticket items like laptops to lower-cost essentials like charging cables. To adapt, we recommend expanding lower-cost essentials accessories like laptop stands or wireless charging stations to meet evolving demand.
2. **Pandemic-driven demands were temporary.** The 2020 laptop boom was short-lived, highlighting the need for data-driven forecasting to optimize inventory planning. For example, if gaming monitor sales surge every Q4, we can stock up in Q3 and run targeted promotions ahead of peak demand to maximize sales while avoiding overstock risks.
3. **Brand strength doesn’t guarantee sales.**  Despite strong branding, iPhones and Bose Headphones underperformed. We recommend partnering with official brands for promotions to drive higher sales. Additionally, running targeted marketing campaigns emphasizing unique value propositions, such as extended warranty or premium customer support, can help attract more buyers.
4. **Timely product launches drive growth.** The Samsung Webcam’s success shows the value of launching the right products at the right time. We recommend monitor demand trends and expand into hybrid work solutions like 4K webcams and wireless conference speakers.
5. **Revenue is overly reliant on a few products.**  With 84% of units sold coming from just three products, we recommend diversifying into adjacent categories. For example, if gaming monitor demand declines, expanding into gaming peripherals like keyboards, mice, or streaming equipment allows us to capture the same target audience while reducing reliance on a few key products. 
6. **Loyalty members are a resilient and high-value revenue source.** Members now outspend non-members by about $30 per order and contribute to more than half of total revenue, proving their value. To increase sign-ups, we recommend offering first-purchase discounts. To increase retention, we recommend implementing a members-only pricing.

# Final Deliverable Tableau Story

The JBmart company-wide town hall presentation walks through the insights and lessons above can be found [here](https://public.tableau.com/app/profile/kai.xiang.chiew/viz/JBmartCompany-WideTownHallWhatcanwelearnfromCovid/Story1). Some extracts are presented below for easy reference. 

![presentatation_title_tableau_story](https://github.com/user-attachments/assets/1ec2f40d-a1f4-42e1-8aec-36c82ec36685)
![presentation_samsung_webcam_story](https://github.com/user-attachments/assets/00e14aa6-1a0d-4087-966c-032586a30416)
![presentation_revenue_loyalty_story](https://github.com/user-attachments/assets/8a82ae32-2751-47ee-83f5-276c4d10a780)

# Appendix: Data Cleaning

We cleaned **108,127** raw records down to **78,849** using the C-L-E-A-N framework:
* **C - Conceptualize**: Defined data grain, focused on critical fields (purchase_date, usd_price, customer_id). **C also stands for Copy**, keep a copy of raw data.
* **L - Locate Solvable Issues**: Duplicates, Formatting, Consistency. Removed duplicates with windows function, corrected date formats, standardized product names, and fixed inconsistent country code.
* **E - Evaluate Unsolvable Issues**: Missing and Nonsensical data. Impute NULL values (usd_price), measure % impacted by NULLs to decide whether column is usable, set nonsensical dates (e.g., delivery_date < purchase_date) to NULL.
* A - **Augment with Calculated Fields or Supplementary Info** from another source. Created days_to_ship and days_to_delivery and added region mappings for better geographic insights.
* N - **Note & Document**: Logged all issues and resolutions in a **changelog Excel file** for transparency.

This process ensured the dataset is clean, structured, and ready for analysis.

Below is a screenshot of the Data Cleaning Changelog Excel file that can be downloaded [here](jbmart_data_cleaning_changelog.xlsx).

![data_cleaning_changelog_excel](https://github.com/user-attachments/assets/30cdb437-292d-400d-85e1-88890d0eb6d3)

