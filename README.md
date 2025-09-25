# TravelTide Customer Segmentation Project

<img width="1162" height="651" alt="Screenshot 2025-08-05 at 15 28 28" src="https://github.com/user-attachments/assets/96f1a852-7b96-4efd-bd5c-18988584ca88" />

---

**Uncovering meaningful traveler groups to power personalized rewards and smarter marketing**

This project explores customer segmentation for TravelTide, a fictional travel booking startup. Using rule-based personas and unsupervised machine learning, I grouped customers into actionable segments that inform loyalty perks and marketing strategies.

* **Dataset**: 5,000+ customers and 50,000+ sessions
* **Techniques**: Rule-based personas, PCA, K-Means, DBSCAN
* **Goal**: Build a segmentation model that balances business relevance with technical quality

## Project Highlights

### Tableau Data Story
* Who are the users of TravelTide?
* How do users interact with TravelTide?
* Where do the TravelTide users go - what do their trips tell us?

<img width="2360" height="1356" alt="image" src="https://github.com/user-attachments/assets/f56227a4-0a5d-478c-85fc-0da39792fb34" />

### Two Approaches Compared
 * Rule-based personas: Business-driven profiles like Business Travelers, Families, and Young Adventurers
 * Machine Learning: K-Means and DBSCAN clustering with PCA

### Key Insights

* K-Means produced 6 balanced, business-friendly clusters (e.g., Frequent Business Travelers, Luxury Explorers, High Cancellation Risk) ￼
* DBSCAN highlighted 49 VIP outliers but lacked business usability ￼
* Rule-based personas were intuitive but too simplistic

### Actionable Outcomes

* Designed personalized perks for each cluster (e.g., airport lounge passes, family packages, romantic getaways
* Built personas & loyalty strategies for targeted marketing
* Delivered findings in a presentation deck, a written report, and a Tableau dashboard

<img width="1852" height="874" alt="image" src="https://github.com/user-attachments/assets/a0725f34-db6f-4d5a-a71e-d0a1cf17a110" />

<img width="1852" height="874" alt="image" src="https://github.com/user-attachments/assets/6df9f01b-8c89-49f6-aa7e-1b2961693c47" />

    
## Project Structure

```
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

## Deliverables

* [Tableau EDA Dashboard](https://public.tableau.com/app/profile/dido.de.boodt/viz/TravelTide_EDA_Dashboards/TravelTideEDADashboard) 
* [Presentation Slides](https://github.com/Dido-D-B/TravelTide_Customer_Segmentation/blob/main/Presentation/TravelTide%20Customer%20Segmentation%20Slides.pdf) (PDF)
* [Detailed Report](https://github.com/Dido-D-B/TravelTide_Customer_Segmentation/blob/main/Presentation/TravlTide%20Customer%20Segmentation%20Report.pdf) (PDF)

## Tools & Skills

* **Python**: Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
* **SQL**: Data cleaning & cohort creation
* **ML**: PCA, K-Means, DBSCAN
* **Visualization**: Tableau, Google Slides
* **Soft Skills**: Translating technical results into business strategy

## How to Use

1. Clone the repo:

   ```
   git clone https://github.com/Dido-D-B/TravelTide_Customer_Segmentation.git
   cd TravelTide_Customer_Segmentation
   ```
   
3.	Open the notebooks with Jupyter or VS Code.

4. Install dependencies:

   ```
   pip install -r requirements.txt
   ```

## Contact

[Dido De Boodt](https://www.linkedin.com/in/dido-de-boodt/)
