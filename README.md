# Motor Vehicle Collisions Data Analysis

## Project Overview
This project involves analyzing motor vehicle collision data from three cities: New York, Chicago, and Austin. The analysis is focused on understanding various aspects of the collisions, such as the frequency of accidents, areas with the highest number of incidents, and patterns involving injuries and fatalities. The project utilized a combination of tools and technologies, including Talend for ETL processes, SQL for data querying, and both Power BI and Tableau for data visualization.

## Technologies and Tools Used
- **Talend:** Used for ETL processes to extract, transform, and load the data from various sources.
- **YData Profiling:** Jupyter notebook used for data profiling and exploration.
- **SQL:** Employed for querying the data and creating the necessary data structures.
- **Power BI & Tableau:** Visualization tools used to create dashboards and reports to represent the analyzed data.
- **Mapping Documentation:** Detailed documentation explaining how the columns from the source data were mapped to the target data structures.

## Project Structure

### ETL Process
- **Talend Files:** Contains all Talend jobs and components used for data extraction, transformation, and loading into the database.

### Data Profiling
- **ydata_profiling.ipynb:** Jupyter notebook that provides an in-depth analysis of the dataset, including data quality checks, distributions, and key insights.

### SQL Scripts
- **SQL Scripts Folder:** Contains all the SQL scripts used for creating tables, querying data, and performing various data transformations.

### Mapping Documentation
- **Mapping Documentation:** This document details how each column from the source datasets was mapped to the target data structures in the database. It includes explanations of any transformations that were applied during the process.

### Visualizations
- **Power BI Folder:** Contains the Power BI dashboard files that provide interactive visualizations of the data.
- **Tableau Folder:** Contains Tableau workbooks that also visualize the data through interactive dashboards.

## How to Run the Project

1. **Set Up Environment:**
   - Ensure that Talend, SQL Server/MySQL, Power BI, and Tableau are installed and configured properly on your machine.

2. **ETL Process:**
   - Use the Talend files to run the ETL jobs, which will extract data from the provided sources, transform it as necessary, and load it into the staging and final target tables in the database.

3. **Data Profiling:**
   - Open the `ydata_profiling.ipynb` notebook in Jupyter and run the cells to understand the structure and quality of the data.

4. **Run SQL Scripts:**
   - Execute the SQL scripts in the provided order to create tables, load data, and perform necessary transformations for analysis.

5. **Mapping Documentation:**
   - Refer to the Mapping Documentation to understand how data was structured and transformed during the ETL process.

6. **Visualize Data:**
   - Open the Power BI and Tableau files to explore the visualizations and gain insights from the data.

## Conclusion
This project highlights the use of advanced data architectures and business intelligence tools to analyze motor vehicle collision data. By leveraging ETL processes, SQL queries, and powerful visualization tools, the project provides a comprehensive view of traffic incidents across multiple cities.
