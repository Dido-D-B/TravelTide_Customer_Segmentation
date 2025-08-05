
<img width="1162" height="651" alt="Screenshot 2025-08-05 at 15 28 28" src="https://github.com/user-attachments/assets/96f1a852-7b96-4efd-bd5c-18988584ca88" />

# TravelTide Customer Segmentation Project

This project focuses on customer segmentation for TravelTide, a fictional travel booking platform. The goal is to group customers into meaningful segments using data exploration and unsupervised machine learning, supporting better marketing and loyalty strategies.

## Project Structure

```bash
TravelTide/
Data/
   ├── session_based_eda.csv
   ├── traveltide_cleaned_cohort_selection.csv
   ├── traveltide_cohort_preprocessed.csv
   └── traveltide_cohort_clusters.csv
SQL/
   └── traveltide_cleaned_chort_selection.sql 
Models/
   ├── dbscan_model.pkl
   └── kmeans_model.pkl
Notebooks/
   ├── TravelTide_Clustering.ipynb 
   ├── TravelTide_Cohort_EDA.ipynb  
   ├── TravelTide_Customer_Segmentation_Perks.ipynb 
   ├── TravelTide_Preprocessing.ipynb 
   └── TravelTide_Sessions_EDA.ipynb
Presentation/ 
   ├── TravelTide Customer Segmentation Slides.pptx  
   └── TravelTide Customer Segmentation Report.pdf
README.md
```

## Summary

- **Objective**: Segment TravelTide users to uncover patterns in behavior and support reward strategies
- **Approach**:
  - Cleaned and preprocessed cohort-based session data
  - Performed exploratory data analysis (EDA)
  - Applied K-Means and DBSCAN clustering with PCA
  - Designed customer personas for each segment
- **Tools Used**: Python (Pandas, Numpy, Scikit-learn, Matplotlib, Seaborn), SQL, Tableau, Google Slides

## Highlights

- Identified 6 distinct customer segments using K-Means Clustering
- Each segment informed a unique loyalty perk or recommendation
- Presented findings in a [slide deck](http://github.com/Dido-D-B/TravelTide_Customer_Segmentation/blob/main/Presentation/TravelTide%20Customer%20Segmentation%20Slides.pdf) and written [report](https://github.com/Dido-D-B/TravelTide_Customer_Segmentation/blob/main/Presentation/TravlTide%20Customer%20Segmentation%20Report.pdf) with Executive Summary and Detailed Report
- Created a [Tableau EDA Dashboard](https://public.tableau.com/app/profile/dido.de.boodt/viz/TravelTide_EDA_Dashboards/TravelTideEDADashboard)


## How to Use

1. Clone the repo:
   ```bash
   git clone https://github.com/Dido-D-B/TravelTide_Customer_Segmentation.git
   cd TravelTide_Customer_Segmentation
   
2.	Open the notebooks with Jupyter or VS Code.

3. (Optional) Install dependencies:
   pip install -r requirements.txt

## Author

[Dido De Boodt](https://www.linkedin.com/in/dido-de-boodt/)
Aspiring Data Analyst and Scientist
