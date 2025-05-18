# TravelTide Customer Segmentation Project

This project focuses on customer segmentation for TravelTide, a fictional travel booking platform. The goal is to group customers into meaningful segments using data exploration and unsupervised machine learning, supporting better marketing and loyalty strategies.

## 📁 Project Structure

TravelTide/
├── Data/
│   ├── session_based_eda.csv
│   ├── traveltide_cleaned_cohort_selection.csv
│   ├── traveltide_cohort_preprocessed.csv
│   └── traveltide_cohort_clusters.csv
│
├── SQL/
│   └── traveltide_cleaned_chort_selection.sql 
│
├── Models/                                              # Saved clustering models
│   ├── dbscan_model.pkl
│   └── kmeans_model.pkl
│
├── Notebooks/                                           # Analysis and modeling notebooks
│   ├── TravelTide_Clustering.ipynb
│   ├── TravelTide_Cohort_EDA.ipynb
│   ├── TravelTide_Customer_Segmentation_Perks.ipynb
│   ├── TravelTide_Preprocessing.ipynb
│   └── TravelTide_Sessions_EDA.ipynb
│
├── Presentation/                                        # Final project deliverables
│   ├── TravelTide Customer Segmentation Slides.pptx
│   └── TravelTide Customer Segmentation Report.pdf
│
├── traveltide_cleaned_chort_selection.sql
└── README.md

## Summary

- **Objective**: Segment TravelTide users to uncover patterns in behavior and support reward strategies
- **Approach**:
  - Cleaned and preprocessed cohort-based session data
  - Performed exploratory data analysis (EDA)
  - Applied K-Means and DBSCAN clustering with PCA
  - Designed customer personas for each segment
- **Tools Used**: Python (Pandas, Numpy, Scikit-learn, Matplotlib, Seaborn), SQL, Tableau, Google Slides

## Highlights

- Identified 6 distinct customer segments using K-Means Clustering:
  - Business Travelers
  - Senior Couples
  - Single Adventurers
- Each segment informed a unique loyalty perk or recommendation
- Presented findings in a slide deck and written report with Executive Summary and Detailed Report
- Tableau EDA Dashboard: https://public.tableau.com/app/profile/dido.de.boodt/viz/TravelTide_EDA_Dashboards/TravelTideEDADashboard

## How to Use

1. Clone the repo:
   ```bash
   git clone https://github.com/Dido-D-B/TravelTide_Customer_Segmentation.git
   cd TravelTide_Customer_Segmentation
   
2.	Open the notebooks with Jupyter or VS Code.

3. (Optional) Install dependencies:
   pip install -r requirements.txt

## Author

Dido De Boodt
Aspiring Data Analyst and Scientist
LinkedIn: https://www.linkedin.com/in/dido-de-boodt/
