# 🌾 Agribusiness Crop Production Analysis

### SQL Data Analyst – Agribusiness Internship | Yuva Intern · Henry Harvin

A practical SQL project focused on preparing and cleaning a public agricultural dataset for further analysis. The project covers the early stages of a data analytics workflow — from dataset acquisition and database import to data quality assessment, cleaning, transformation, and validation.

---

## 📌 Project Overview

This project was completed as part of the **Week 1** activities of the SQL Data Analyst – Agribusiness Internship.

The objective was to work with a real-world agricultural dataset and demonstrate how raw data can be prepared for reliable analysis using SQL.

The project focuses on:

* Importing a publicly available agricultural dataset into MySQL
* Profiling the raw data to identify quality issues
* Checking missing values and duplicate records
* Identifying formatting inconsistencies
* Cleaning and standardizing text fields
* Converting raw numeric values into appropriate data types
* Preserving missing values appropriately
* Validating the cleaned dataset

---

## 📊 Dataset

**Dataset:** India Crop Production – State wise
**Source:** Kaggle
**Records:** 246,091
**Columns:** 7
**Time Period:** 1997–2015

### Dataset Columns

| Column          | Description              |
| --------------- | ------------------------ |
| `State_Name`    | Name of the state        |
| `District_Name` | Name of the district     |
| `Crop_Year`     | Year of crop production  |
| `Season`        | Agricultural season      |
| `Crop`          | Crop name                |
| `Area`          | Area under cultivation   |
| `Production`    | Crop production quantity |

🔗 **Dataset Source:**
[India Crop Production – State wise](https://www.kaggle.com/datasets/aravindpcoder/indian-crop-production)

---

## 🛠️ Tools & Technologies

* **MySQL 8.0**
* **MySQL Workbench**
* **SQL**
* **GitHub**

---

## 🔍 Project Workflow

```text
Public Dataset
      ↓
Data Acquisition
      ↓
MySQL Raw Table
      ↓
Data Quality Profiling
      ↓
Missing Value Analysis
      ↓
Duplicate & Formatting Checks
      ↓
Data Cleaning
      ↓
Cleaned Table
      ↓
Post-Cleaning Validation
```

---

## 🧹 Data Cleaning

The raw dataset was intentionally preserved in a separate table before cleaning.

The following cleaning operations were performed:

* Removed leading and trailing whitespace using `trim()`
* Converted blank production values into SQL `null`
* Converted area and production values into numeric data types
* Preserved records with missing production values instead of replacing them with zero
* Created a separate cleaned table to keep the raw data unchanged

### Raw → Cleaned Structure

```text
crop_production_raw
        ↓
   SQL Cleaning
        ↓
crop_production_cleaned
```

---

## 📈 Data Quality Findings

The initial profiling identified:

* **3,730** missing production values
* **0** exact duplicate records
* **14,566** state records containing extra whitespace
* **1,985** crop records containing extra whitespace
* **0** district records requiring whitespace correction
* Crop years ranging from **1997 to 2015**
* **33** states
* **646** districts
* **6** seasons
* **124** crops

After cleaning:

* Raw records: **246,091**
* Cleaned records: **246,091**
* Missing production values retained as `NULL`: **3,730**
* Non-missing production values: **242,361**
* Area values available: **246,091**
* No extra whitespace remained in the cleaned state, season, and crop fields.

---

## 📁 Repository Structure

```text
agribusiness-crop-production/
│
├── sql/
│   └── week1_agribusiness.sql
│
├── docs/
│   └── Week_1_Agribusiness_Report.docx
│
└── README.md
```

---

## 🎯 Key Learning Outcomes

This project provided practical experience with:

* Working with real-world agricultural data
* Importing CSV data into MySQL
* SQL-based data profiling
* Handling missing values
* Duplicate detection
* Text standardization
* Data type conversion
* Creating cleaned datasets
* Validating data after transformation
* Documenting a reproducible data-cleaning workflow

---

## 👩‍💻 Internship Context

**Program:** Yuva Intern
**Organization:** Henry Harvin
**Role:** SQL Data Analyst – Agribusiness Internship
**Project:** Week 1 – Data Acquisition, Cleaning & Preliminary Transformation

---

### 📄 Documentation

The detailed methodology, SQL queries, screenshots, decisions, challenges, and validation results are available in the project report included in this repository.

