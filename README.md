# Data Exploration of Covid 19 using SQL (Microsoft's SQL Server Management Studio) and Tableau

Performing data exploration of Covid-19 using Microsoft's SQL Server Management Studio and Tableau, analyzing a dataset spanning from January 2020 to May 2023.

## Table of Contents
- [Business Problem](#business-problem)
  * [Objective](#objective)
  * [Goal](#goal)
- [Data Source](#data-source)
- [Tableau Viz link](#tableau-viz-link)
- [Methods](#methods)
- [Tech Stack](#tech-stack)
- [SQL Queries Analysis](#sql-queries-analysis)
  * [Query Methods](#query-methods)
- [Types of Graphs](#types-of-graphs)
- [Quick Analysis of Results](#quick-analysis-of-results)
  * [Tableau Dashboard](#tableau-dashboard)
  * [Key findings](#key-findings)
  * [Limitations and Suggestions](#limitations-and-suggestions)


## Business Problem
A healthcare startup needs to perform data exploration of worldwide Covid-19 data. They aim to monitor and track patients' Covid-19 symptoms and outcomes on a global scale to understand the long-term effects of the disease, support recovery, and provide personalized care, including telemedicine enhancements.

### Objective
The objective is to perform data exploration of Covid-19 using Microsoft's SQL Server Management Studio and Tableau. By analyzing a dataset spanning from January 2020 to May 2023, the startup aims to gain a deeper understanding of the long-term effects of Covid-19 on patients, support their recovery process, and provide personalized care.

### Goal
- Monitor and Track Symptoms: Collect and analyze global Covid-19 patient data to monitor and track symptoms, enabling healthcare providers to identify trends, patterns, and potential complications associated with the disease.
- Understand Long-term Effects: Explore the dataset to gain a comprehensive understanding of the long-term effects of Covid-19 on a global scale, including identifying common post-recovery challenges, persistent symptoms, and potential health complications.
- Contribute to Global Understanding: By performing data exploration on a worldwide scale, the startup aims to contribute to the global understanding of Covid-19, its long-term effects, and improve strategies for managing and supporting patients' recovery.



## Data Source
[Our World in Data link](https://ourworldindata.org/covid-deaths)

## Tableau Viz link

## Methods
- SQL querying
- Data visualization (Tableau)

## Tech Stack
- Microsoft SQL Server Management Studio
- Tableau

## SQL Queries Analysis
### Query Methods
- Column division to obtain a motality percentage in the United Kingdom.
- Identified the percentage of the population who were infected in the United Kindgdom using aggregate function (MAX).
- Identified country with the highest infection rate and aggregate global rates.
- Joined the two table sources.
- Used CTEs (Common Table Expression) to be able to perform calculations. This calculaties the rolling number of people vaccinated, recursively.
- Created a temp table named #PercentPopulationVaccinated and populated it with data from two source tables (CovidDeaths and CovidVaccinations), calculating the rolling number of people vaccinated, and then selects all data from the temporary table with an additional column representing the percentage of rolling people vaccinated per population, ordered by location and date.
- Used CAST function to convert data types like bigint to float to be able to display decimal points 
- Created a 'View' to store data for later visualisations

## Types of Graphs
- Forecasting Line Chart: This chart combines historical data with a predictive model to visualize future trends or projections for four countries based on the existing data patterns.
- Geographic Map: This shows the percent of the population affected across different countries. 
- Heatmap: The heatmap here is associated with the geographic map. It can represent the intensity or density of Covid-19 cases in different geographic areas. It uses color gradients to visually depict the severity of the situation, allowing for quick identification of hotspots or regions with higher infection rates.
- Bar Chart: Displays the mortality count per continent.
- Table: Displays global numbers.

## Quick Analysis of Results
### Tableau Dashboard
### Key findings
- Cyprus retains the highest infection rate percentage at 73.5% which has been reported
- United Kingdom mortality rate as of May 2023: 0.9%
- High percentage of people vaccinated
-
### Limitations and Suggestions
#### Data Completeness
- COVID-19 datasets may have missing or incomplete data due to various reasons such as reporting delays, inconsistencies in data collection, or incomplete testing. This can lead to gaps in the dataset, making it challenging to obtain a comprehensive understanding of the situation.

#### Data Accuracy 
- Datasets might contain inaccuracies due to errors in data entry, data cleaning, or data integration processes. Inaccurate data can lead to incorrect analyses and interpretations.
- This may also be exacerbated by differing methods in which countries collect data and the lack global standarization ineffciencies.

#### Data Granularity
- COVID-19 data is often reported at different levels of granularity, such as country, region, or city. Inconsistencies in granularity can hinder data analysis and make it challenging to draw meaningful conclusions at a specific level.

#### Data Bias
- Datasets might exhibit biases due to variations in testing practices, access to healthcare, or reporting biases in different regions or population groups. These biases can skew the analysis results and provide an incomplete picture of the COVID-19 situation.

#### Data Integration
- COVID-19 datasets often need to be combined with other datasets (e.g., demographic or healthcare data) to gain more comprehensive insights. Integrating heterogeneous datasets from various sources can be complex and time-consuming.
